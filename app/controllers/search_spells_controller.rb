require 'pp'
require 'spellparse'
require 'htmlentities'

NORMAL_SELECT = "DISTINCT spells.*, r1.name AS reagent1_name, r2.name AS reagent2_name, skill.name AS skill_name, target.name AS target_name, resist.name AS resist_name, recourse.name AS recourse_name"
NORMAL_JOIN = "LEFT JOIN reagents AS r1 ON r1.id = spells.reagent1_id LEFT JOIN reagents as r2 ON r2.id = spells.reagent2_id INNER JOIN skill_types as skill ON skill.id = spells.skill_id "
NORMAL_JOIN += "INNER JOIN target_types AS target ON target.id = spells.target_type_id LEFT JOIN resist_types AS resist ON resist.id = spells.resist_type_id "
NORMAL_JOIN += "LEFT JOIN spells AS recourse ON recourse.id = spells.recourse_id "

class SearchSpellsController < ApplicationController

	before_filter :sanitize_params

protected
	def valid_int?(i)
		return i.to_i().to_s() == i
	end

	def sanitize_params
		# Validate all parameters
		# This is ugly, but works. Rails makes this kind of crap WAY too complex IMO, so I'm using the brute-force method
		errors = ""
		arrClasses = [ :war, :clr, :pal, :rng, :shd, :dur, :mnk, :brd, :rog, :shm, :nec, :wiz, :mag, :enc, :bst ]
		arrResists = [ :magic_resist, :cold_resist, :fire_resist, :poison_resist, :disease_resist ]
		regexAllowed = "^[a-zA-Z0-9'!]*$"

        if (params[:minmana] and params[:minmana] != "")
			errors += "<br/>Min mana must be an integer" if (not valid_int?(params[:minmana]))	
		end
           
		if (params[:maxmana] and params[:maxmana] != "")
			errors += "<br/>Max mana must be an integer" if (not valid_int?(params[:maxmana]))	
		end

		if (params[:levelmin] and params[:levelmin] != "")
			errors += "<br/>Min level must be an integer" if (not valid_int?(params[:levelmin]))	
		end
           
		if (params[:levelmax] and params[:levelmax] != "")
			errors += "<br/>Max level must be an integer" if (not valid_int?(params[:levelmax]))	
		end

		if (params[:spellid] and params[:spellid] != "")
			errors += "<br/>Spell ID must be an integer" if (not valid_int?(params[:spellid]))	
		end

		if (params[:spell_id] and params[:spell_id] != "")
			errors += "<br/>Spell ID must be an integer" if (not valid_int?(params[:spell_id]))	
		end

		if (params[:beneficial] and params[:beneficial] != "")
			errors += "<br/>Beneficial flag must be an integer" if (not valid_int?(params[:beneficial]))	
		end

		if (params[:requiresreagent] and params[:requiresreagent] != "")
			errors += "<br/>Reagent flag must be an integer" if (not valid_int?(params[:beneficial]))	
		end

		arrClasses.each do |myclass|
			if (params[myclass] and params[myclass] != "")
				errors += "<br/>One or more classes has an invalid value" if (not valid_int?(params[myclass]))	
				break
			end
		end
		
		arrResists.each do |resist|
			if (params[resist] and params[resist] != "")
				errors += "<br/>One or more resists has an invalid value" if (not valid_int?(params[resist]))	
				break
			end
		end

		if (params[:spell_name] != nil and params[:spell_name] != "")
			puts("Spell name: " + params[:spell_name])
			unless (params[:spell_name] =~ /#{regexAllowed}/)
				errors += "<br/>Spell name contains an invalid character"
			end	
		end

		if (params[:cast_msg] != nil and params[:cast_msg] != "")
			unless (params[:cast_msg] =~ /#{regexAllowed}/)
				errors += "<br/>Cast message contains an invalid character"
			end	
		end

		# Propagate to display pages
		flash[:notice] = errors
	end
	
	def create
		head :ok
	end

public
	def show
		if (params[:id] == "sod-logo")
			head :ok
		else
			render :index
		end
	end
	
	def GetSpellEffects(spell_id, beneficial, duration, extra)
		hashStackedSpells = Hash.new
		arrEffects = Array.new
        effects = Effect.select("*").where("spell_id=" + spell_id.to_s).order("slot")
        #pp effects

        effects.each do |e|
			extra_spell = ""
			extra_data = ""

			next if not e.real_effect

			if (e.effect == 123)
				# Forced spell stacking, set extra_spell as the effect that won't stack
				stack = EffectType.select("name").where("id=" + e.base1.to_s)
				if (stack.first != nil)
					extra_spell = stack.first.name
					#puts "*** Stack: id=" + e.base1.to_s + " which is " + extra_spell
				end
	
				# Also get a list of all spells that share this stacking conflict - output it at the bottom
		        stacked_effects = Effect.select("DISTINCT *").joins("INNER JOIN spells ON effects.spell_id = spells.id").where("effect = 123 and base1=" + e.base1.to_s + " and spell_id !=" + e.spell_id.to_s + " and max = " + e.max.to_s).order("spells.name")
				stacked_effects.each do |stacked_spell|
					# Get the name
					unless hashStackedSpells.has_key?(stacked_spell.spell_id)
						hashStackedSpells[stacked_spell.spell_id] = stacked_spell.name 
					end
				end
				
			elsif (e.effect == 83 or e.effect == 88 or e.effect == 104)
				# Transport spells. Need to extract additional data from other slots
				ew = ""
				z = ""
	
				effects.each do |e2|
					case e2.slot
						when 2
							ew = e2.base1.to_s
						when 3
							z = e2.base1.to_s
					end
				end

				ns = e.base1.to_s

				# All values are -1 for succor-type spells
				if (ns == "-1" and ew == "-1" and z == "-1")
					extra_data = " (safe spot)"
				else
					extra_data = " (" + ns + ", " + ew + ", " + z + ")"			
				end
			elsif (e.effect == 58)
				# Illusion - figure out the name and send it as "extra"
				illusion = Illusion.select("name").where("model1=" + e.base1.to_s + " and model2=" + e.max.to_s)
				extra = ""
				extra = (illusion.first != nil) ? illusion.first.name : "" 
			elsif (e.formula == 100 or e.effect == 139 or e.effect == 153)
				# Try to get a spell name in the case of formulas with a value 100, as well as effect ID 153. This happens for procs
				spelltemp = Spell.select("name").where("spells.id = " + e.base1.to_s)
				if (spelltemp.first != nil)
					extra_spell = spelltemp.first.name
				end
			end

            strEffect = ParseSpellsTxt.GetSpellEffect(e.effect, e.base1, e.base2, e.max, e.formula, 1, duration, extra, extra_spell)
            if (strEffect != "")
				strEffect = "Slot " + e.slot.to_s + ": " + strEffect
				strEffect = strEffect + extra_data if extra_data != ""
            	arrEffects << strEffect
			end

			# Get stacking conflicts not already captured - this is done by looking for beneficial spells with the same effect and slot
			# Note that base1=0 is just legacy stuff, and should be ignored
			# Don't need to do for detrimental spells
			if (beneficial)
				unless (e.base1 == 0 or e.effect == 32)		# 32 is summoned - no silly stacks there!
					stacked_effects = Effect.select("DISTINCT *").joins("INNER JOIN spells ON effects.spell_id = spells.id").where("beneficial = 1 and base1 != 0 and effect = " + e.effect.to_s + " and slot = " + e.slot.to_s).order("spells.name")
	    	        stacked_effects.each do |stacked_spell|
	        	        # Get the name
	            	    unless hashStackedSpells.has_key?(stacked_spell.spell_id)
	                	    hashStackedSpells[stacked_spell.spell_id] = stacked_spell.name
	        	        end
	            	end
				end
			end
        end

		return arrEffects, hashStackedSpells
	end

	def GetSpellClasses(spell_id)
		return MapSpellToCharClass.find_by_sql("SELECT group_concat(CONCAT(char_classes.name, '(', m.level, ')') SEPARATOR ', ') AS classes FROM char_classes INNER JOIN map_spell_to_char_classes as m ON m.class_id = char_classes.id WHERE m.spell_id = " + spell_id.to_s + " ORDER BY level, char_classes.name")
	end

	def detail
		# Called to render spell detail view
		#pp "Spell ID: " + params[:spell_id].to_s
		if (flash[:notice] != "")
			render :spelldetail
			return
		end

		if (params[:spell_id] != nil and params[:spell_id] != "")
			spell_id = params[:spell_id]
		else
			spell_id = @spell_id
		end

		conditions = "spells.id = " + spell_id.to_s
		@spells = Spell.select(NORMAL_SELECT).joins(NORMAL_JOIN).where(conditions).order("spells.name")
		
		# For a given spell, pull in its classes
		@spells.each do | spell |
			@class = GetSpellClasses(spell.id)
			spell["classes"] = @class.first["classes"]

			# Also pull in effects and calculate results
			@arrEffects,@hashStacks = GetSpellEffects(spell.id, spell.beneficial, spell.duration, spell.extra)
		end
		
		render :spelldetail
	end

	def index
		
		if (params[:s])
			if (flash[:notice] != "")
				render :spelldetail
				return
			end

			name = params[:spell_name].gsub("'", "''")
			castmsg = params[:cast_msg].gsub("'", "''")
			manamin = params[:minmana]
			manamax = params[:maxmana]
			levelmin = params[:levelmin]
			levelmax = params[:levelmax]

			arrConditions = Array.new
			arrConditionsClass = Array.new
			arrConditionsResist = Array.new
			conditionsResist = ""
			conditionsClass = ""

			arrConditions << "spells.name LIKE '%" + name + "%'" if name != ""
			if (castmsg != "")
				arrConditions << "(spells.castonyou LIKE '%" + castmsg + "%' or spells.castonother LIKE '%" + castmsg + "%')"
			end

			arrConditions << "spells.mana_cost >= " + manamin.to_s if manamin != ""
			arrConditions << "spells.mana_cost <= " + manamax.to_s if manamax != ""
			arrConditions << "(spells.reagent1_id > 0 OR spells.reagent2_id > 0)" if params[:requiresreagent]
			arrConditions << "spells.beneficial = 't'" if params[:beneficial] == "2"
			arrConditions << "spells.beneficial = 'f'" if params[:beneficial] == "3"
			arrConditions << "char_classes.level >= " + levelmin.to_s if levelmin != ""
			arrConditions << "char_classes.level <= " + levelmax.to_s if levelmax != ""
	
			arrConditionsResist << "spells.resist_type_id = 1" if params[:magic_resist]
			arrConditionsResist << "spells.resist_type_id = 2" if params[:fire_resist]
			arrConditionsResist << "spells.resist_type_id = 3" if params[:cold_resist]
			arrConditionsResist << "spells.resist_type_id = 4" if params[:poison_resist]
			arrConditionsResist << "spells.resist_type_id = 5" if params[:disease_resist]

			arrConditionsClass << "char_classes.class_id = 1" if params[:war]
			arrConditionsClass << "char_classes.class_id = 2" if params[:clr]
			arrConditionsClass << "char_classes.class_id = 3" if params[:pal]
			arrConditionsClass << "char_classes.class_id = 4" if params[:rng]
			arrConditionsClass << "char_classes.class_id = 5" if params[:shd]
			arrConditionsClass << "char_classes.class_id = 6" if params[:dru]
			arrConditionsClass << "char_classes.class_id = 7" if params[:mnk]
			arrConditionsClass << "char_classes.class_id = 8" if params[:brd]
			arrConditionsClass << "char_classes.class_id = 9" if params[:rog]
			arrConditionsClass << "char_classes.class_id = 10" if params[:shm]
			arrConditionsClass << "char_classes.class_id = 11" if params[:nec]
			arrConditionsClass << "char_classes.class_id = 12" if params[:wiz]
			arrConditionsClass << "char_classes.class_id = 13" if params[:mag]
			arrConditionsClass << "char_classes.class_id = 14" if params[:enc]
			arrConditionsClass << "char_classes.class_id = 15" if params[:bst]

			conditionsResist = arrConditionsResist.join(" or ")
			conditionsClass = arrConditionsClass.join(" or ")
			arrConditions << "(" + conditionsResist + ")" if conditionsResist != ""
			arrConditions << "(" + conditionsClass + ")" if conditionsClass != ""

			conditions = arrConditions.join(" and ")	
			#puts("Conditions: " + conditions)

			join = NORMAL_JOIN
			join += " LEFT JOIN map_spell_to_char_classes as char_classes ON char_classes.spell_id = spells.id"

			@spells = Spell.select(NORMAL_SELECT).joins(join).where(conditions).order("spells.name")
			
			# For a given spell, pull in its classes
			@spells.each do | spell |
				@class = MapSpellToCharClass.find_by_sql("SELECT group_concat(CONCAT(char_classes.name, '(', m.level, ')') SEPARATOR ', ') AS classes FROM char_classes INNER JOIN map_spell_to_char_classes as m ON m.class_id = char_classes.id WHERE m.spell_id = " + spell["id"].to_s + " ORDER BY level, name")
				spell["classes"] = @class.first["classes"]
			end

			if (@spells.length == 1)
				@spell_id = @spells.first.id
				@class = GetSpellClasses(@spell_id)

            	# Also pull in effects and calculate results
            	@arrEffects,@hashStacks = GetSpellEffects(@spell_id, @spells.first.beneficial, @spells.first.duration, @spells.first.extra)

				render :spelldetail
			else
				render :spelllist
			end
		else
			# Just rendering the search page - help out by creating an array of combo box stuff
		end
	end

	def spelldetail
		render :spelldetail
	end

	def search

	end
end


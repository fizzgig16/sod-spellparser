require 'pp'
require 'spellparse'
require 'htmlentities'

NORMAL_SELECT = "DISTINCT spells.*, r1.name AS reagent1_name, r2.name AS reagent2_name, skill.name AS skill_name, target.name AS target_name, resist.name AS resist_name, recourse.name AS recourse_name"
NORMAL_JOIN = "LEFT JOIN reagents AS r1 ON r1.id = spells.reagent1_id LEFT JOIN reagents as r2 ON r2.id = spells.reagent2_id INNER JOIN skill_types as skill ON skill.id = spells.skill_id "
NORMAL_JOIN += "INNER JOIN target_types AS target ON target.id = spells.target_type_id LEFT JOIN resist_types AS resist ON resist.id = spells.resist_type_id "
NORMAL_JOIN += "LEFT JOIN spells AS recourse ON recourse.id = spells.recourse_id "

class SearchSpellsController < ApplicationController
	
	def create
	
	end

	def show
	
	end
	
	def GetSpellEffects(spell_id, duration, extra)
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
				if (ns == "-1" and ew == "-1" and z = "-1")
					extra_data = " (safe spot)"
				else
					extra_data = " (" + ns + ", " + ew + ", " + z + ")"			
				end
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
        end

		return arrEffects
	end

	def GetSpellClasses(spell_id)
		return MapSpellToCharClass.find_by_sql("SELECT group_concat(CONCAT(char_classes.name, '(', m.level, ')') SEPARATOR ', ') AS classes FROM char_classes INNER JOIN map_spell_to_char_classes as m ON m.class_id = char_classes.id WHERE m.spell_id = " + spell_id.to_s + " ORDER BY level, char_classes.name")
	end

	def detail
		# Called to render spell detail view
		#pp "Spell ID: " + params[:spell_id].to_s
		if (params[:spell_id] != nil and params[:spell_id] != "")
			spell_id = params[:spell_id]
		else
			spell_id = @spell_id
		end

		conditions = "spells.id = " + spell_id.to_s
		@spells = Spell.select(NORMAL_SELECT).joins(NORMAL_JOIN).where(conditions).order("spells.name")
		
		# For a given spell, pull in its classes
		@spells.each do | spell |
			pp "Recourse ID: " + spell.recourse_id.to_s
			@class = GetSpellClasses(spell.id)
			spell["classes"] = @class.first["classes"]

			# Also pull in effects and calculate results
			@arrEffects = GetSpellEffects(spell.id, spell.duration, spell.extra)
		end
		
		render :spelldetail
	end

	def index
		if (params[:s])
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

			arrConditions << "mana_cost >= " + manamin.to_s if manamin != ""
			arrConditions << "mana_cost <= " + manamax.to_s if manamax != ""
			arrConditions << "(reagent1_id > 0 OR reagent2_id > 0)" if params[:requiresreagent]
			arrConditions << "spells.beneficial = 't'" if params[:beneficial] == "2"
			arrConditions << "spells.beneficial = 'f'" if params[:beneficial] == "3"
			arrConditions << "char_classes.level >= " + levelmin.to_s if levelmin != ""
			arrConditions << "char_classes.level <= " + levelmax.to_s if levelmax != ""
	
			arrConditionsResist << "resist_type_id = 1" if params[:magic_resist]
			arrConditionsResist << "resist_type_id = 2" if params[:fire_resist]
			arrConditionsResist << "resist_type_id = 3" if params[:cold_resist]
			arrConditionsResist << "resist_type_id = 4" if params[:poison_resist]
			arrConditionsResist << "resist_type_id = 5" if params[:disease_resist]

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
            	@arrEffects = GetSpellEffects(@spell_id, @spells.first.duration, @spells.first.extra)

				render :spelldetail
			else
				render :spelllist
			end
		end
	end

	def spelldetail
		render :spelldetail
	end

	def search

	end
end


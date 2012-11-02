#require 'ftools'
require 'spellparse'
require 'sqlite3'
require 'pp'

class UploadController < ApplicationController

	def create
    	tmp = params[:file_upload][:my_file].tempfile
		file = File.join("public", params[:file_upload][:my_file].original_filename)
		FileUtils.cp tmp.path, file

		# Parse here
		Spell.delete_all
		MapSpellToCharClass.delete_all
		Effect.delete_all

		parser = ParseSpellsTxt.new
		arrSpells = parser.ParseFile("spells_us.txt")
		arrSpells.each do |spell|
    		strClasses = ""
	    	#if (spell["drulvl"] != "255")
		    #	strClasses = "DRU(" + spell["drulvl"].to_s() + ")"
			#end
			
			recSpell = Spell.new
			recSpell.id = spell["id"].to_i
			recSpell.name = spell["name"]
			recSpell.extra = spell["extra"]
			recSpell.youcast = spell["youcast"]
        	recSpell.othercasts = spell["othercasts"]
        	recSpell.castonyou = spell["onyou"]
        	recSpell.castonother = spell["onother"]
        	recSpell.range = spell["range"]
        	recSpell.ae_range = spell["aerange"]
        	recSpell.push = spell["push"]
        	recSpell.cast_time = spell["casttime"]
        	recSpell.recast_time = spell["recasttime"]
        	recSpell.duration = spell["duration"]
        	recSpell.ae_duration = spell["aeduration"]
        	recSpell.mana_cost = spell["manacost"]
        	recSpell.skill_id = spell["skillid"]
			#spell["icon1"]
        	#spell["icon2"]
        	recSpell.reagent1_id = spell["reagent1id"]
        	recSpell.reagent2_id = spell["reagent2id"]
        	recSpell.reagent1qty = spell["reagent1qty"]
        	recSpell.reagent2qty = spell["reagent2qty"]
        	recSpell.spell_type_id = spell["spelltype"]
        	recSpell.resist_type_id = spell["resisttype"]
        	recSpell.target_type_id = spell["targetid"]
        	recSpell.zone_type_id = spell["zonetypeid"]
        	recSpell.resist_adj = spell["resistadj"]
			recSpell.beneficial = spell["beneficial"]

			recSpell.save

			# Class mapping
			#pp spell
			#raise

			for i in 0..14	# Go through each class, see if they can use this particular spell	
				level = spell[(i + 104).to_s + "lvl"].to_i
				next if (level == 0 or level == 255)
				recCharMap = MapSpellToCharClass.new
				recCharMap.spell_id = spell["id"].to_i
				recCharMap.class_id = i + 1
				recCharMap.level = level
				recCharMap.save
			end

			# Now go through effects (done by slot)
			for i in 0..11
				# Is this a real effect? (effect id < 200)
				effectid = spell["sloteffectid"][i]
				if (effectid.to_i < 200)
					# Get the rest of the effect data
					formula = spell["sloteffectformulaval"][i]
					base1 = spell["sloteffectbase1"][i]
					base2 = spell["sloteffectbase2"][i]
					max = spell["sloteffectmax"][i]
					
					recEffect = Effect.new
					recEffect.effect = effectid
					recEffect.spell_id = spell["id"].to_i
					recEffect.slot = (i + 1).to_s
					recEffect.formula = formula
					recEffect.base1 = base1
					recEffect.base2 = base2
					recEffect.max = max

					recEffect.save
				end
				#puts "Slot effect: " + effectid.to_s
			end

			#puts(spell["id"].to_s() + ": " + spell["name"] + " > " + strClasses)
			#  puts(spell["reagent1id"])
			#        puts(spell["reagent2id"])
			#        end
			#raise if spell["id"].to_i > 10
		end

		FileUtils.rm file	
	end

end


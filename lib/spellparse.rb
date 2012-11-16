require 'friendlynames'

class ParseSpellsTxt
	
	@@hashClassIndex = Hash.new()
	@@hashClassIndex[104] = "war"
	@@hashClassIndex[105] = "clr"
	@@hashClassIndex[106] = "pal"
	@@hashClassIndex[107] = "rng"
	@@hashClassIndex[108] = "shd"
	@@hashClassIndex[109] = "dru"
	@@hashClassIndex[110] = "mnk"
	@@hashClassIndex[111] = "brd"
	@@hashClassIndex[112] = "rog"
	@@hashClassIndex[113] = "shm"
	@@hashClassIndex[114] = "nec"
	@@hashClassIndex[115] = "wiz"
	@@hashClassIndex[116] = "mag"
	@@hashClassIndex[117] = "enc"
	@@hashClassIndex[118] = "bst"

	def ParseFile(strFilename)
		arrSpells = Array.new
		f = File.open("spells_us.txt", "r")
		f.each do | line |
			#next unless line.start_with?("3256")
			hashLine = ReadRecord(line.chomp!())
			arrSpells << hashLine
		end

		f.close()

		return arrSpells
	end

	def ReadRecord(strRecord)
		# Reads an individual line from spells_us.txt
		# Format is as follows (separated by ^ - number represents the array index)
		# 0: id
		# 1: name
		# 3: "extra" - can contain things like teleport destinations
		# 4: message when you cast
		# 5: message when someone else casts
		# 6: message when cast on you
		# 7: message when cast on someone else
		# 9: range
		# 10: AE range
		# 11: push
		# 13: cast time
		# 15: recast time
		# 16: effect formula
		# 17: duration 
		# 18: AE duration
		# 19: mana cost
		# 56: icon 1
		# 58: reagent 1 id
		# 59: reagent 2 id
		# 62: reagent quantity
		# 63: reagent quantity
		# 83: spell type (beneficial)
		# 85: resist type
		# 100: spell school (evocation, etc.)
		# 104: warrior min level
		# 105: cleric min level
		# 106: paladin min level
		# 107: ranger min level
		# 108: shadowknight min level
		# 109: druid min level
		# 110: monk min level
		# 111: bard min level
		# 112: rogue min level
		# 113: shaman min level
		# 114: necro min level
		# 115: wizard min level
		# 116: magician min level
		# 117: enchanter min level
		# 118: beastloard min level
		# 144: icon 2
		# 147: resist adjust
		# 150: recourse spell ID
		#
		# 20-31: minimum values on effects (see 86-97)
		# 32-55: max values (32 - 43 seem to be weird)
		# 70-81: effect formulas
		
		hashSpell = Hash.new()
		arrParts = strRecord.split('^')
		if (arrParts.length < 145)	# sanity check
			puts("Invalid line: begins with " + strRecord[0..10])
			return
		end

		hashSpell["id"] = arrParts[0]
		hashSpell["name"] = arrParts[1]
		hashSpell["extra"] = arrParts[3]
		hashSpell["youcast"] = arrParts[4]
		hashSpell["othercasts"] = arrParts[5]
		hashSpell["onyou"] = arrParts[6]
		hashSpell["onother"] = arrParts[7]
		hashSpell["range"] = arrParts[9]
		hashSpell["aerange"] = arrParts[10]
		hashSpell["push"] = arrParts[11]
		hashSpell["casttime"] = arrParts[13]
		hashSpell["recasttime"] = arrParts[15]
		hashSpell["duration"] = arrParts[17]
		hashSpell["aeduration"] = arrParts[18]
		hashSpell["manacost"] = arrParts[19]
		hashSpell["icon1"] = arrParts[56]
		hashSpell["icon2"] = arrParts[144]
		hashSpell["reagent1id"] = arrParts[58]
		hashSpell["reagent2id"] = arrParts[59]
		hashSpell["reagent1qty"] = arrParts[62]
		hashSpell["reagent2qty"] = arrParts[63]
		hashSpell["beneficial"] = arrParts[83]
		hashSpell["resisttype"] = arrParts[85]
		hashSpell["targetid"] = arrParts[98]
		hashSpell["effectformula"] = arrParts[16]
		hashSpell["skillid"] = arrParts[100]
		hashSpell["zonetypeid"] = arrParts[101]
		hashSpell["resistadj"] = arrParts[147]
		hashSpell["recourseid"] = arrParts[150]
		
		# Get per-class levels
		for i in 104..118
			level = arrParts[i]
			hashSpell[i.to_s + "lvl"] = level
		end

		# Get effects
		sloteffectformvalue = Hash.new
		sloteffectid = Hash.new
		sloteffectbase1 = Hash.new
		sloteffectbase2 = Hash.new
		sloteffectmax = Hash.new

		for i in 86..98
			effectid = arrParts[i]
			effectformula = arrParts[i - 16]
			base1val = arrParts[i - 66].to_i
			maxval = arrParts[i - 42].to_i
			base2val = arrParts[i - 54].to_i
	
			sloteffectformvalue[i - 86] = effectformula
			sloteffectid[i - 86] = effectid
			sloteffectbase1[i - 86] = base1val
			sloteffectbase2[i - 86] = base2val
			sloteffectmax[i - 86] = maxval
			#puts "Slot " + (i - 86).to_s + ": Effect type:" + effectid.to_s + " Effect amount: " + effect
		end
		
		hashSpell["sloteffectformulaval"] = sloteffectformvalue
		hashSpell["sloteffectid"] = sloteffectid
		hashSpell["sloteffectbase1"] = sloteffectbase1
		hashSpell["sloteffectbase2"] = sloteffectbase2
		hashSpell["sloteffectmax"] = sloteffectmax

		return hashSpell
	end

	def self.GetSpellEffect(effect, base1, base2, max, formula, level, duration, myextra, extra_spell_name)
		return GetSpellEffectInner(effect, base1, base2, max, formula, level, duration, myextra, extra_spell_name, true)
	end

	def self.GetSpellEffectNoHTML(effect, base1, base2, max, formula, level, duration, myextra, extra_spell_name)
		return GetSpellEffectInner(effect, base1, base2, max, formula, level, duration, myextra, extra_spell_name, false)
	end

	def self.GetSpellEffectInner(effect, base1, base2, max, formula, level, duration, myextra, extra_spell_name, use_html)
		effectamt = "0"

		return "" if ((effect == 254) or (effect == 10 && (base1 < 1 or base1 > 255)))
		
		value = CalculateEffectValue(formula, base1, max, duration, level)
		range = CalculateEffectRangeValue(formula, base1, max, duration, level)
		maxlevel = max > 0 ? (" up to level " + max.to_s) : ""
		extra = " " + myextra
		repeating = duration > 0 ? " per tick" : ""

		case effect
			when 0
				return GetEffectDescriptor("Current HP", value) + (duration > 0 ? " per tick" : "")
			when 1
				return GetEffectDescriptor("AC", ((value * 0.29).to_i))
			when 2
				return GetEffectDescriptor("ATK", value) + range
			when 3
				return GetEffectDescriptor("Movement Speed", value)
			when 4
				return GetEffectDescriptor("STR", value) + range
			when 5
				return GetEffectDescriptor("DEX", value) + range
			when 6
				return GetEffectDescriptor("AGI", value) + range
			when 7
				return GetEffectDescriptor("STA", value) + range
			when 8
				return GetEffectDescriptor("INT", value) + range
			when 9
				return GetEffectDescriptor("WIS", value) + range
			when 10
				return GetEffectDescriptor("CHA", value) + range
			when 11
				return GetEffectPercentDescriptor("Melee Haste", value - 100, max - 100)
			when 12
				#return "Invisibility (Enhanced " + base1.to_s + ")" if base1 > 1
				return "Invisibility"
			when 13
				#return "See Invisible (Enhanced " + base1.to_s + ")" if base1 > 1
				return "See Invisible"
			when 14
				return "Enduring Breath"
			when 15
				return GetEffectDescriptor("Current Mana", value) + (duration > 0 ? " per tick" : "")
			when 18
				return "Pacify" 
			when 19
				return GetEffectDescriptor("Faction", value) 
			when 20
				return "Blind" 
			when 21
				return "Stun for " + (base1 / 1000).to_s + " seconds" + maxlevel
			when 22
				return "Charm" 
			when 23
				return "Fear" 
			when 24
				return GetEffectDescriptor("Stamina Loss", -value)
			when 25
				return "Bind" 
			when 26
				return "Gate to secondary bind point" if base1 > 1 
				return "Gate"
			when 27
				return "Dispel (" + value.to_s + ")"
			when 28
				return "Invisibility to Undead"
			when 29
				return "Invisibility to Animals"
			when 30
				return "Decrease agro radius to " + value.to_s + maxlevel
			when 31
				return "Mezmerize" + maxlevel
			when 32
				# TODO: Try to look up a friendly name
				return "Summon Item  " + base1.to_s
			when 33
				# Try to get a friendly name
				name = FriendlyNames.has_key?(extra.strip) ? FriendlyNames[extra.strip] : extra
				return "Summon " + name
			when 35
				return GetEffectDescriptor("Disease Counter", value)
			when 36
				return GetEffectDescriptor("Poison Counter", value)
			when 40
				return "Invulnerability"
			when 41
				return "Destroy"
			when 42
				return "Shadowstep"
			when 44
				return "Stacking: Delayed heal marker (" + value.to_s + ")"
			when 46
				return GetEffectDescriptor("Fire Resist", value)
			when 47
				return GetEffectDescriptor("Cold Resist", value)
			when 48
				return GetEffectDescriptor("Poison Resist", value)
			when 49
				return GetEffectDescriptor("Disease Resist", value)
			when 50
				return GetEffectDescriptor("Magic Resist", value)
			when 52
				return "Sense Undead"
			when 53
				return "Sense Summoned"
			when 54
				return "Sense Animal"
			when 55
				return "Absorb Damage: " + value.to_s + " points"
			when 56
				return "True North"
			when 57
				return "Levitate"
			when 58
				# Illusion - this should have the illusion name sent to it as part of extra data
				return "Illusion: " + extra
			when 59
				return "Damage Shield: " + (-value).to_s + " points"
			when 61
				return "Identify Item"
			when 63
               	return ("Memory Blur (" + (value + 40).to_s + "% Chance)") if ((value + 40) < 100)
                return "Memory Blur"
			when 64
				return "Stun and Spin for " + (value / 1000).to_s + " seconds" + maxlevel
			when 65
				return "Infravision"
			when 66
				return "Ultravision"
			when 67
				return "Eye of Zomm"
			when 68
				return "Reclaim Pet"
			when 69
				return GetEffectDescriptor("Max HP", value) + range
			when 71
				return "Summon Pet: " + extra
			when 73
				return "Bind Sight"
			when 74
                return "Feign Death (" + value.to_s + "% Chance)" if (value < 100)
                return "Feign Death"
            when 75
                return "Voice Graft"
            when 76
                return "Sentinel"
            when 77
                return "Locate Corpse"
            when 78
                return "Absorb Spell Damage: " + value.to_s + " hit points"
            when 79
                return GetEffectDescriptor("Current HP", value) + range + " (If TODO: Fix effect 79)" if (base2 > 0)
                return GetEffectDescriptor("Current HP", value) + range
            when 81
                return "Resurrect with " + value.to_s + "% XP" 
            when 82
                return "Summon Player"
            when 83,88
				name = FriendlyNames.has_key?(extra.strip) ? FriendlyNames[extra.strip] : extra
                return "Teleport to " + name
            when 84
                return "Gravity Flux"
            when 85
				effect_name = use_html ? ("<a href='/search_spells/detail?spell_id=" + base1.to_s + "'>" + extra_spell_name + "</a>") : extra_spell_name
				return "Add Weapon Proc: " + effect_name
			when 86
                return "Decrease Social Radius to " + value.to_s + maxlevel
            when 87
                return GetEffectPercentDescriptorSingle("Magnification", value)
            when 89
                return GetEffectPercentDescriptorSingle("Player Size", base1 - 100)
            when 91
                return "Summon Corpse up to level " + base1.to_s
			when 92
                return GetEffectDescriptor("Hate", value)
            when 93
                return "Stop Rain"
            when 94
                return "Cancel if Combat Initiated"
            when 95
                return "Sacrifice"
            when 96
                return "Silence"
            when 97
                return GetEffectDescriptor("Max Mana", value)
            when 98
                return GetEffectPercentDescriptorSingle("Melee Haste v2", value - 100)
            when 99
                return "Root"
            when 100
                return GetEffectDescriptor("Current HP", value) + repeating + range + " (If FIXME: Effect 100)" if (base2 > 0)
                return GetEffectDescriptor("Current HP", value) + repeating + range
            when 102
                return "Fear Immunity"
            when 103,106,108
				name = FriendlyNames.has_key?(extra.strip) ? FriendlyNames[extra.strip] : extra
                return "Summon Pet: " + name
            when 104
				name = FriendlyNames.has_key?(extra.strip) ? FriendlyNames[extra.strip] : extra
                return "Translocate to " + name
            when 105
                return "Inhibit Gate"
            when 109
                return "Summon: Item " + base1.to_i
			when 110
				# This one is a bit special - effect depends on formula
				return GetEffectPercentDescriptorSingle("Archery Accuracy", base1) if formula == 200
				return GetEffectPercentDescriptorSingle("Archery Damage", base1) if formula == 400
            when 111
                return GetEffectDescriptor("All Resists", value)
            when 112
                return GetEffectDescriptor("Effective Casting Level", value)
            when 113
                return "Summon Mount: " + extra
            when 114
                #return GetEffectPercentDescriptorSingle("Hate Generated", value)
				return GetEffectPercentDescriptorSingle("Agro", value - 100)
            when 115
                return "Reset Hunger Counter"
            when 116
                return GetEffectDescriptor("Curse Counter", value)
            when 117
                return "Make Weapon Magical"
            when 118
                return GetEffectDescriptor("Singing Skill", value)
            when 119
                return GetEffectPercentDescriptorSingle("Melee Haste v3", value)
            when 120
                return GetEffectPercentDescriptorSingle("Healing Taken", base1)
            when 121
                return GetEffectDescriptor("Reverse Damage Shield", -value)
            when 123
                # Forced spell stacking. base1 is the effect that drives the stacking
				# Example: aegolism has effect 123 in slot 1, with base1=69, which is Total HP
				# This means that aego will NOT stack with spells that have an effect modifying Total HP in slot 1
				# Clear as mud?
				return "Forced Spell Stacking: will not stack with other spells affecting " + extra_spell_name + " in this slot"
			when 125
				return GetEffectPercentDescriptorSingle("Chance of Critical Heals", base1)
			when 127
				return GetEffectPercentDescriptorSingle("Casting Time", base1 - 100)
			when 132
				return GetEffectPercentDescriptorSingle("Mana Cost", -value)
			when 139
				return "Excludes spell: " + (use_html ? ("<a href='/search_spells/detail?spell_id=" + base1.to_s + "'>" + extra_spell_name + "</a>") : extra_spell_name)
			when 153
				# Autocast
				effect_name = use_html ? ("<a href='/search_spells/detail?spell_id=" + base1.to_s + "'>" + extra_spell_name + "</a>") : extra_spell_name
				return "Auto cast: " + effect_name 
			else
				return "Unknown effect: " + effect.to_s
		end

		return effectamt
	end

	def self.CalculateEffectValue(formula, base1, max, level)
		return CalculateEffectValue(formula, base1, max, 1, level)
	end

	def self.CalculateEffectValue(formula, base1, max, tick, level)
		return base1 if formula == 0
		
		if (formula == 100 or formula == 200 or formula == 400)
			return max if (max > 0 and base1 > max)
			return base1
		end
	
		effectamt = 0
		case formula
            when 1
                effectamt = level * 1
            when 2
                effectamt = level * 2
            when 3
                effectamt = level * 3
            when 4
                effectamt = level * 4
            when 5
                effectamt = level * 5
            when 6
                effectamt = level * 6
            when 7
                effectamt = level * 7
            when 8
                effectamt = level * 8
            when 9
                effectamt = level * 9
            when 10
                effectamt = level * 10
            when 100
                effectamt = 0
            when 101
                effectamt = level / 2
            when 102
				effectamt = level
			when 103
                effectamt = level * 2
            when 104
                effectamt = level * 3
            when 105
                effectamt = level * 4
			when 107
				effectamt = 0
			when 108
				effectamt = 0
            when 109
                effectamt = level / 4
            when 110
                effectamt = level / 5
            when 111
                effectamt = level / 6
            when 112
                effectamt = level / 7
            when 113
                effectamt = level / 8
            when 114
                effectamt = level / 9
            when 119
                effectamt = level / 7
            when 121
                effectamt = level / 2
            when 122
                effectamt = 0
            when 169
                effectamt = level * 18
			else
				return "Unknown effect: " + formula.to_s
        end

		value = base1.abs + effectamt
		value = -value if (base1 < 0)

		return value
	end
	
	def self.CalculateEffectRangeValue(formula, base1, max, duration, level)
		start = CalculateEffectValue(formula, base1, max, 1, level)
		finish = CalculateEffectValue(formula, base1, max, duration, level).abs
		direction = start.abs < finish.abs ? "increasing" : "decreasing"

		case formula
			when 122
				return direction + " to " + finish.to_s + " at 12/tick"
			when 123
				return "Random: " + base1.to_s + " to " + (max * ((base1 >= 0) ? 1 : -1)).to_s
			else
				return direction + " to " + finish.to_s + " at " + (formula - 1000).to_s + "/tick" if (formula > 1000 and formula < 2000)
		end

		return ""
	end

	def self.GetEffectDescriptor(name, value)
		return (value < 0 ? "Decrease" : "Increase") + " " + name + " by " + value.abs.to_s
	end

	def self.GetEffectPercentDescriptorSingle(name, value)
		return GetEffectPercentDescriptor(name, value, value)
	end

	def self.GetEffectPercentDescriptor(name, min, max)
		if (min.abs > max.abs)
			temp = min
			min = max
			max = temp
		end

		min = 1 if (min == 0 and max != 0)
		
		direction = (max < 0 ? "Decrease" : "Increase")
		return direction + " " + name + " by " + max.abs.to_s + "%" if min == max
		return direction + " " + name + " by " + min.abs.to_s + "%" + " to " + max.abs.to_s + "%"
	end
end


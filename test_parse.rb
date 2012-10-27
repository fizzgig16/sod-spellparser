#!/usr/bin/env ruby

require 'spellparse'

parser = ParseSpellsTxt.new
arrSpells = parser.ParseFile("spells_us.txt")
arrSpells.each do |spell|
	strClasses = ""
	if (spell["drulvl"] != "255")
		strClasses = "DRU(" + spell["drulvl"].to_s() + ")"
	end

	#puts(spell["id"].to_s() + ": " + spell["name"] + " > " + strClasses)
	puts(spell["reagent1id"])
	puts(spell["reagent2id"])
end

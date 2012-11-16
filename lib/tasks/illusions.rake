#!/usr/bin/env ruby

namespace :illusions do 
    desc 'Update database with illusion data'

	task :update => :environment do


		arrIllusions = [
            ['Chainmail', -2, 2], 
            ['Leather', -2, 1], 
            ['Platemail', -2, 3], 
            ['Female', -1, 0], 
            ['Void Touched', -1, 2], 
            ['Human', 1, 0], 
            ['Barbarian', 2, 0], 
            ['Erudite', 3, 0], 
            ['Wood Elf', 4, 0], 
            ['High Elf', 5, 0], 
            ['Dark Elf', 6, 0], 
            ['Half-Elf', 7, 0], 
            ['Dwarf', 8, 0], 
            ['Troll', 9, 0], 
            ['Ogre', 10, 0], 
            ['Halfling', 11, 0], 
            ['Gnome', 12, 0], 
            ['Werewolf', 14, 0], 
            ['Froglok', 27, 0], 
            ['Werefrog', 27, 1], 
            ['Goblin', 40, 0], 
            ['Wolf', 42, 0], 
            ['Bear', 43, 0], 
            ['Imp', 46, 0], 
            ['Dragon', 49, 0], 
            ['Fae', 56, 0], 
            ['Skeleton', 60, 0], 
            ['Form of the Gladiator', 66, 2], 
            ['Form of the Frozen Monolith', 66, 1], 
            ['Water Elemental', 75, 2], 
            ['Fire Elemental', 75, 1], 
            ['Air Elemental', 75, 3], 
            ['Earth Elemental', 75, 0], 
			['Scarecrow', 82, 0],
            ['Spectre', 85, 0], 
            ['Dragonkin', 89, 0], 
            ['Oldest Fear', 95, 0], 
            ['Eyesore', 108, 0], 
            ['Spirit Wolf', 120, 0], 
            ['Hated One', 123, 0], 
            ['Horse', 124, 0], 
            ['Runic: Avatar of Destruction', 127, 2], 
            ['Somatic Bond', 127, 2], 
            ['Concealed Strikes', 127, 0], 
            ['Iksar', 128, 0], 
            ['Vah', 130, 0], 
            ['Yiv Goblin', 137, 0], 
            ['Minor Illusion', 142, 0], 
            ['Treeform', 143, 0], 
            ['Nightmarr', 150, 0], 
            ['Iksar Skeleton', 161, 0], 
            ['Portal Passage', 230, 0], 
            ['Plaguebringer', 235, 0], 
            ['?Moon?', 241, 0], 
            ['Banshee', 250, 0], 
            ['Mad Fever', 258, 0], 
            ['Treefrog', 316, 0], 
            ['Taldorian', 330, 0], 
            ['Demon Beast', 348, 0], 
            ['Hound', 356, 0], 
            ['Relic: Master of Death', 367, 0], 
            ['Scion', 367, 1], 
            ['Jyre', 367, 3], 
            ['Call to Nemesis', 367, 2], 
            ['Crate', 376, 0], 
            ['Burial', 382, 0], 
            ['King', 384, 0] 
		]

		illusions = [ ]
		Illusion.delete_all
		arrIllusions.each do |illusion|
			recIllusion = Illusion.new
			recIllusion.name = illusion[0]
			recIllusion.model1 = illusion[1]
			recIllusion.model2 = illusion[2]

			illusions << recIllusion
		end

		Illusion.import illusions

    end
end

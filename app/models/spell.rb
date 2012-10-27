class Spell < ActiveRecord::Base
	#serialize :reagent1_name, Hash

	attr_accessor :reagent1_name
	attr_accessor :reagent2_name
	attr_accessor :classes
	attr_accessor :skill_name
	attr_accessor :target_name
	attr_accessor :resist_name

	#def rname
    #	attributes['rname']
  	#end

	#has_one :reagents, :foreign_key => 'id'	

end


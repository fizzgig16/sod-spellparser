class Reagent < ActiveRecord::Base
	:belongs_to spell, :foreign_key => 'reagent1_id'
	:belongs_to spell, :foreign_key => 'reagent2_id'
end

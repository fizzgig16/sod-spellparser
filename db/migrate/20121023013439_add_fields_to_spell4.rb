class AddFieldsToSpell4 < ActiveRecord::Migration
  def self.up
	change_table :spells do |t|
    	t.integer :skill_id
	end
  end

  def self.down
  end
end

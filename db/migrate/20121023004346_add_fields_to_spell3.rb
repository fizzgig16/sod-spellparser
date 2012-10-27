class AddFieldsToSpell3 < ActiveRecord::Migration
  def self.up
	change_table :spells do |t|
    	t.integer :push
	end
  end

  def self.down
  end
end

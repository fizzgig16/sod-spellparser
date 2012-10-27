class AddFieldsToSpell2 < ActiveRecord::Migration
  def self.up
	change_table :spells do |t|
    	t.integer :ae_range
	end
  end

  def self.down
  end
end

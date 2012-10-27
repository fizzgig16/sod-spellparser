class AddFieldsToSpell < ActiveRecord::Migration
  def self.up
	change_table :spells do |t|
		t.string :youcast
    	t.string :othercasts
    	t.string :castonyou
    	t.string :castonother
    	t.integer :reagent1qty
    	t.integer :reagent2qty
    	t.integer :spell_type_id
	end
  end

  def self.down
  end
end

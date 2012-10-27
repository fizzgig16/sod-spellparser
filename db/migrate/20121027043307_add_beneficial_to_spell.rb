class AddBeneficialToSpell < ActiveRecord::Migration
  def self.up
	change_table :spells do |t|
        t.boolean :beneficial
	end
  end

  def self.down
  end
end

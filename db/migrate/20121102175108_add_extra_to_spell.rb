class AddExtraToSpell < ActiveRecord::Migration
  def self.up
    change_table :spells do |t|
        t.string :extra
	end
  end

  def self.down
  end
end

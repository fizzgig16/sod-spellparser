class CreateSpells < ActiveRecord::Migration
  def self.up
    create_table :spells do |t|
      t.integer :id
      t.string :name
      t.integer :type_id
      t.integer :range
      t.integer :ae_range
	  t.integer :push
	  t.integer :target_type_id
      t.integer :usable_by_id
      t.integer :mana_cost
      t.decimal :cast_time
      t.decimal :recast_time
      t.integer :duration
      t.integer :ae_duration
      t.integer :reagent1_id
      t.integer :reagent2_id
      t.integer :zone_type_id
	  t.integer :resist_type_id
	  t.integer :resist_adj

      t.timestamps
    end
  end

  def self.down
    drop_table :spells
  end
end

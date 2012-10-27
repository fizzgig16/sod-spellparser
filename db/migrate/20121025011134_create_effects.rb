class CreateEffects < ActiveRecord::Migration
  def self.up
    create_table :effects do |t|
      t.integer :spell_id
      t.integer :slot
      t.integer :effect
      t.integer :formula
      t.integer :base1
      t.integer :base2
      t.integer :max

      t.timestamps
    end
  end

  def self.down
    drop_table :effects
  end
end

class CreateEffectTypes < ActiveRecord::Migration
  def self.up
    create_table :effect_types do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :effect_types
  end
end

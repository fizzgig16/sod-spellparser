class CreateMapSpellToCharClasses < ActiveRecord::Migration
  def self.up
    create_table :map_spell_to_char_classes do |t|
      t.integer :spell_id
      t.integer :class_id
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :map_spell_to_char_classes
  end
end

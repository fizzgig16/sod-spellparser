class CreateResistTypes < ActiveRecord::Migration
  def self.up
    create_table :resist_types do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :resist_types
  end
end

class CreateZoneTypes < ActiveRecord::Migration
  def self.up
    create_table :zone_types do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :zone_types
  end
end

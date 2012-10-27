class CreateTargetTypes < ActiveRecord::Migration
  def self.up
    create_table :target_types do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :target_types
  end
end

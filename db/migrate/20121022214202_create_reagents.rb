class CreateReagents < ActiveRecord::Migration
  def self.up
    create_table :reagents do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :reagents
  end
end

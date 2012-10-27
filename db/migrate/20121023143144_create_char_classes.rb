class CreateCharClasses < ActiveRecord::Migration
  def self.up
    create_table :char_classes do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :char_classes
  end
end

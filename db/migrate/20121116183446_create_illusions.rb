class CreateIllusions < ActiveRecord::Migration
  def change
    create_table :illusions do |t|
      t.integer :id
      t.string :name
      t.integer :model1
      t.integer :model2

      t.timestamps
    end
  end
end

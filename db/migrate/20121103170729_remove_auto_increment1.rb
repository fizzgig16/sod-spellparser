class RemoveAutoIncrement1 < ActiveRecord::Migration
  def up
	change_column(:effect_types, :id, :integer, :null => false)
  end

  def down
  end
end

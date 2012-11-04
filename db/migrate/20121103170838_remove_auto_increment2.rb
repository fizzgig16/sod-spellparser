class RemoveAutoIncrement2 < ActiveRecord::Migration
  def up
	change_column(:spells, :id, :integer, :null => false)
	change_column(:target_types, :id, :integer, :null => false)
	change_column(:resist_types, :id, :integer, :null => false)
	change_column(:zone_types, :id, :integer, :null => false)
	change_column(:skill_types, :id, :integer, :null => false)
	change_column(:reagents, :id, :integer, :null => false)
	change_column(:char_classes, :id, :integer, :null => false)
  end

  def down
  end
end

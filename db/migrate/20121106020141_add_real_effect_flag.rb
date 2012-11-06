class AddRealEffectFlag < ActiveRecord::Migration
  def up
	# Fixing a local screw-up
	if column_exists? :spells, :real_effect
		remove_column :spells, :real_effect
	end

    change_table :effects do |t|
        t.boolean :real_effect
    end

  end

  def down
  end
end

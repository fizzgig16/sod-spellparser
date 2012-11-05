class AddRecourseToSpells < ActiveRecord::Migration
  def change
	change_table :spells do |t|
        t.integer :recourse_id
	end
  end
end

class AddLongNameToClass < ActiveRecord::Migration
  def self.up
    change_table :char_classes do |t|
        t.string :long_name
	end
  end

  def self.down
  end
end

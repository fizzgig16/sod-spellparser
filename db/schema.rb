# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121116183446) do

  create_table "char_classes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "long_name"
  end

  create_table "effect_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "effects", :force => true do |t|
    t.integer  "spell_id"
    t.integer  "slot"
    t.integer  "effect"
    t.integer  "formula"
    t.integer  "base1"
    t.integer  "base2"
    t.integer  "max"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "real_effect"
  end

  create_table "illusions", :force => true do |t|
    t.string   "name"
    t.integer  "model1"
    t.integer  "model2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "map_spell_to_char_classes", :force => true do |t|
    t.integer  "spell_id"
    t.integer  "class_id"
    t.integer  "level"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reagents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "resist_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "skill_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spells", :force => true do |t|
    t.string   "name"
    t.integer  "type_id"
    t.integer  "range"
    t.integer  "ae_range"
    t.integer  "push"
    t.integer  "target_type_id"
    t.integer  "usable_by_id"
    t.integer  "mana_cost"
    t.decimal  "cast_time",      :precision => 10, :scale => 0
    t.decimal  "recast_time",    :precision => 10, :scale => 0
    t.integer  "duration"
    t.integer  "ae_duration"
    t.integer  "reagent1_id"
    t.integer  "reagent2_id"
    t.integer  "zone_type_id"
    t.integer  "resist_type_id"
    t.integer  "resist_adj"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "youcast"
    t.string   "othercasts"
    t.string   "castonyou"
    t.string   "castonother"
    t.integer  "reagent1qty"
    t.integer  "reagent2qty"
    t.integer  "spell_type_id"
    t.integer  "skill_id"
    t.boolean  "beneficial"
    t.string   "extra"
    t.integer  "recourse_id"
  end

  create_table "target_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "zone_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

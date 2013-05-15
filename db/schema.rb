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

ActiveRecord::Schema.define(:version => 20130510013658) do

  create_table "abord_hot_notes", :force => true do |t|
    t.integer  "note_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "abord_hot_notes", ["note_id"], :name => "index_abord_hot_notes_on_note_id"
  add_index "abord_hot_notes", ["order"], :name => "index_abord_hot_notes_on_order"

  create_table "area_intro_cates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "area_intros", :force => true do |t|
    t.integer  "area_id"
    t.text     "intro"
    t.string   "title"
    t.integer  "area_intro_cate_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "area_intros", ["area_id"], :name => "index_area_intros_on_area_id"
  add_index "area_intros", ["area_intro_cate_id"], :name => "index_area_intros_on_area_intro_cate_id"

  create_table "area_note_relations", :force => true do |t|
    t.integer  "note_id"
    t.integer  "area_id"
    t.integer  "nation_id"
    t.integer  "nation_group_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "area_note_relations", ["area_id"], :name => "index_area_note_relations_on_area_id"
  add_index "area_note_relations", ["nation_group_id"], :name => "index_area_note_relations_on_nation_group_id"
  add_index "area_note_relations", ["nation_id"], :name => "index_area_note_relations_on_nation_id"
  add_index "area_note_relations", ["note_id"], :name => "index_area_note_relations_on_note_id"

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.string   "name_cn"
    t.string   "link"
    t.integer  "nation_id"
    t.string   "pic"
    t.string   "note_link"
    t.string   "site_link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "areas", ["link"], :name => "index_areas_on_link"
  add_index "areas", ["nation_id"], :name => "index_areas_on_nation_id"

  create_table "best_notes", :force => true do |t|
    t.integer  "note_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "best_notes", ["note_id"], :name => "index_best_notes_on_note_id"
  add_index "best_notes", ["order"], :name => "index_best_notes_on_order"

  create_table "citi_and_city_group_relations", :force => true do |t|
    t.integer  "area_id"
    t.integer  "city_group_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "citi_and_city_group_relations", ["area_id"], :name => "index_citi_and_city_group_relations_on_area_id"
  add_index "citi_and_city_group_relations", ["city_group_id"], :name => "index_citi_and_city_group_relations_on_city_group_id"

  create_table "city_groups", :force => true do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "most_view_notes", :force => true do |t|
    t.integer  "note_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "most_view_notes", ["note_id"], :name => "index_most_view_notes_on_note_id"
  add_index "most_view_notes", ["order"], :name => "index_most_view_notes_on_order"

  create_table "nation_groups", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name_cn"
  end

  create_table "nation_intros", :force => true do |t|
    t.integer  "nation_id"
    t.text     "intro"
    t.string   "title"
    t.integer  "area_intro_cate_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "nation_intros", ["area_intro_cate_id"], :name => "index_nation_intros_on_area_intro_cate_id"
  add_index "nation_intros", ["nation_id"], :name => "index_nation_intros_on_nation_id"

  create_table "nations", :force => true do |t|
    t.string   "name"
    t.string   "name_cn"
    t.string   "link"
    t.integer  "state_id"
    t.integer  "nation_group_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "nations", ["link"], :name => "index_nations_on_link"
  add_index "nations", ["nation_group_id"], :name => "index_nations_on_nation_group_id"
  add_index "nations", ["state_id"], :name => "index_nations_on_state_id"

  create_table "new_notes", :force => true do |t|
    t.integer  "note_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "new_notes", ["note_id"], :name => "index_new_notes_on_note_id"
  add_index "new_notes", ["order"], :name => "index_new_notes_on_order"

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.integer  "read_num"
    t.string   "date"
    t.string   "pic"
    t.integer  "order_best"
    t.integer  "order_new"
    t.string   "link"
    t.text     "content",    :limit => 16777215
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "notes", ["link"], :name => "index_notes_on_link"
  add_index "notes", ["title"], :name => "index_notes_on_title"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "pic"
    t.integer  "rank"
    t.integer  "area_id"
    t.integer  "nation_id"
    t.integer  "nation_group_id"
    t.text     "info"
    t.text     "intro"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "pics"
  end

  add_index "sites", ["area_id"], :name => "index_sites_on_area_id"
  add_index "sites", ["nation_group_id"], :name => "index_sites_on_nation_group_id"
  add_index "sites", ["nation_id"], :name => "index_sites_on_nation_id"

  create_table "states", :force => true do |t|
    t.string   "name_cn"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

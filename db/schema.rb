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

ActiveRecord::Schema.define(:version => 20120202220019) do

  create_table "studios", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "telephone"
    t.string   "fax"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "studios", ["email"], :name => "index_studios_on_email", :unique => true

  create_table "styles", :force => true do |t|
    t.string   "name"
    t.integer  "studio_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "styles", ["studio_id", "created_at"], :name => "index_styles_on_studio_id_and_created_at"

  create_table "term_groups", :force => true do |t|
    t.string   "name"
    t.integer  "style_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "phonetic_spelling"
    t.string   "name_translated"
  end

  create_table "terms", :force => true do |t|
    t.string   "term"
    t.string   "term_translated"
    t.text     "description"
    t.string   "phonetic_spelling"
    t.integer  "term_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end

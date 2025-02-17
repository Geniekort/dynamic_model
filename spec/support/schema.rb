ActiveRecord::Schema.define(version: 20100401102949) do

  create_table "data_typeas", force: true do |t|
    t.string   "title"
    t.string   "plural_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_attributes", force: true do |t|
    t.string   "name"
    t.json     "validation_definition"
    t.integer  "data_type_id", index: true
    t.string   "attribute_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_objects", force: true do |t|
    t.json     "data"
    t.integer  "data_type_id", index: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

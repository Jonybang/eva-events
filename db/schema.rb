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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151210180455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "code"
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "color_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.boolean  "active"
    t.string   "type"
    t.integer  "forum_id"
    t.integer  "person_id"
    t.string   "alias"
    t.integer  "event_type_id"
    t.integer  "room_id"
    t.integer  "color_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "events", ["forum_id"], name: "index_events_on_forum_id", using: :btree
  add_index "events", ["person_id"], name: "index_events_on_person_id", using: :btree

  create_table "events_admins", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "event_id"
  end

  add_index "events_admins", ["event_id"], name: "index_events_admins_on_event_id", using: :btree
  add_index "events_admins", ["person_id"], name: "index_events_admins_on_person_id", using: :btree

  create_table "events_members", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "event_id"
  end

  add_index "events_members", ["event_id"], name: "index_events_members_on_event_id", using: :btree
  add_index "events_members", ["person_id"], name: "index_events_members_on_person_id", using: :btree

  create_table "events_visitors", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "event_id"
  end

  add_index "events_visitors", ["event_id"], name: "index_events_visitors_on_event_id", using: :btree
  add_index "events_visitors", ["person_id"], name: "index_events_visitors_on_person_id", using: :btree

  create_table "events_volunteers", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "event_id"
  end

  add_index "events_volunteers", ["event_id"], name: "index_events_volunteers_on_event_id", using: :btree
  add_index "events_volunteers", ["person_id"], name: "index_events_volunteers_on_person_id", using: :btree

  create_table "forums", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "description"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.boolean  "published"
    t.string   "time_zone"
    t.integer  "organization_id"
    t.integer  "person_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "forums", ["organization_id"], name: "index_forums_on_organization_id", using: :btree
  add_index "forums", ["person_id"], name: "index_forums_on_person_id", using: :btree

  create_table "forums_admins", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "forum_id"
  end

  add_index "forums_admins", ["forum_id"], name: "index_forums_admins_on_forum_id", using: :btree
  add_index "forums_admins", ["person_id"], name: "index_forums_admins_on_person_id", using: :btree

  create_table "forums_members", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "forum_id"
  end

  add_index "forums_members", ["forum_id"], name: "index_forums_members_on_forum_id", using: :btree
  add_index "forums_members", ["person_id"], name: "index_forums_members_on_person_id", using: :btree

  create_table "forums_posts", id: false, force: :cascade do |t|
    t.integer "forum_id"
    t.integer "post_id"
  end

  add_index "forums_posts", ["forum_id"], name: "index_forums_posts_on_forum_id", using: :btree
  add_index "forums_posts", ["post_id"], name: "index_forums_posts_on_post_id", using: :btree

  create_table "forums_visitors", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "forum_id"
  end

  add_index "forums_visitors", ["forum_id"], name: "index_forums_visitors_on_forum_id", using: :btree
  add_index "forums_visitors", ["person_id"], name: "index_forums_visitors_on_person_id", using: :btree

  create_table "forums_volunteers", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "forum_id"
  end

  add_index "forums_volunteers", ["forum_id"], name: "index_forums_volunteers_on_forum_id", using: :btree
  add_index "forums_volunteers", ["person_id"], name: "index_forums_volunteers_on_person_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "fullname"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "forum_id"
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "likes", ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "completed"
    t.boolean  "published"
    t.boolean  "important"
    t.boolean  "for_visitor",        default: true
    t.boolean  "for_member",         default: true
    t.boolean  "for_volunteer",      default: true
    t.boolean  "for_admin",          default: true
    t.datetime "published_time"
    t.datetime "changed_time"
    t.integer  "forum_id"
    t.integer  "person_id"
    t.integer  "newsable_id"
    t.string   "newsable_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "news", ["forum_id"], name: "index_news_on_forum_id", using: :btree
  add_index "news", ["newsable_type", "newsable_id"], name: "index_news_on_newsable_type_and_newsable_id", using: :btree
  add_index "news", ["person_id"], name: "index_news_on_person_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string  "name"
    t.integer "person_id"
  end

  add_index "organizations", ["person_id"], name: "index_organizations_on_person_id", using: :btree

  create_table "organizations_teams", id: false, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "person_id"
  end

  add_index "organizations_teams", ["organization_id"], name: "index_organizations_teams_on_organization_id", using: :btree
  add_index "organizations_teams", ["person_id"], name: "index_organizations_teams_on_person_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string  "name"
    t.string  "number"
    t.integer "forum_id"
    t.string  "alias"
    t.integer "position"
  end

  add_index "rooms", ["forum_id"], name: "index_rooms_on_forum_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.boolean  "completed"
    t.integer  "forum_id"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tasks", ["forum_id"], name: "index_tasks_on_forum_id", using: :btree
  add_index "tasks", ["person_id"], name: "index_tasks_on_person_id", using: :btree

  create_table "tasks_performers", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "task_id"
  end

  add_index "tasks_performers", ["person_id"], name: "index_tasks_performers_on_person_id", using: :btree
  add_index "tasks_performers", ["task_id"], name: "index_tasks_performers_on_task_id", using: :btree

  create_table "telegram_users", force: :cascade do |t|
    t.string   "chat_id"
    t.integer  "forum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "telegram_users", ["forum_id"], name: "index_telegram_users_on_forum_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.boolean  "anonym"
    t.string   "name"
    t.string   "image"
    t.datetime "registered_on"
    t.integer  "person_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "is_admin"
  end

end

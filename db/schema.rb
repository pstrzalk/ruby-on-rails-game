# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_29_220837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_actions", force: :cascade do |t|
    t.bigint "game_id"
    t.string "action_type"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_actions_on_game_id"
  end

  create_table "game_players", force: :cascade do |t|
    t.bigint "game_id"
    t.uuid "identity"
    t.boolean "alive", default: true
    t.boolean "winner", default: false
    t.integer "position_horizontal", default: 0
    t.integer "position_vertical", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_players_on_game_id"
  end

  create_table "game_times", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "current"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_times_on_game_id"
  end

  create_table "game_worlds", force: :cascade do |t|
    t.integer "rotations", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.bigint "world_id"
    t.integer "train_position"
    t.bigint "last_action_id"
    t.bigint "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lock_version", default: 0
    t.index ["world_id"], name: "index_games_on_world_id"
  end

end

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

ActiveRecord::Schema.define(version: 20160418094459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flood_risk_engine_addresses", force: :cascade do |t|
    t.string   "premises",            limit: 200
    t.string   "street_address",      limit: 160
    t.string   "locality",            limit: 70
    t.string   "city",                limit: 30
    t.string   "postcode",            limit: 8
    t.integer  "county_province_id"
    t.string   "country_iso",         limit: 3
    t.integer  "address_type",                    default: 0,  null: false
    t.string   "organisation",        limit: 255, default: "", null: false
    t.integer  "contact_id"
    t.date     "state_date"
    t.string   "blpu_state_code"
    t.string   "postal_address_code"
    t.string   "logical_status_code"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "flood_risk_engine_contacts", force: :cascade do |t|
    t.integer  "contact_type",                default: 0, null: false
    t.integer  "title",                       default: 0, null: false
    t.string   "suffix"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "position"
    t.string   "email_address"
    t.string   "telephone_number"
    t.integer  "partnership_organisation_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "flood_risk_engine_contacts", ["email_address"], name: "index_flood_risk_engine_contacts_on_email_address", using: :btree
  add_index "flood_risk_engine_contacts", ["partnership_organisation_id"], name: "fre_contacts_partnership_organisation_id", using: :btree

  create_table "flood_risk_engine_enrollments", force: :cascade do |t|
    t.integer  "applicant_contact_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "organisation_id"
    t.string   "step",                 limit: 50
    t.integer  "site_address_id"
  end

  add_index "flood_risk_engine_enrollments", ["applicant_contact_id"], name: "index_flood_risk_engine_enrollments_on_applicant_contact_id", using: :btree
  add_index "flood_risk_engine_enrollments", ["organisation_id"], name: "index_flood_risk_engine_enrollments_on_organisation_id", using: :btree
  add_index "flood_risk_engine_enrollments", ["site_address_id"], name: "index_flood_risk_engine_enrollments_on_site_address_id", using: :btree

  create_table "flood_risk_engine_enrollments_exemptions", force: :cascade do |t|
    t.integer  "enrollment_id",             null: false
    t.integer  "exemption_id",              null: false
    t.integer  "status",        default: 0
    t.datetime "expires_at"
    t.datetime "valid_from"
  end

  add_index "flood_risk_engine_enrollments_exemptions", ["enrollment_id", "exemption_id"], name: "fre_enrollments_exemptions_enrollment_id_exemption_id", unique: true, using: :btree

  create_table "flood_risk_engine_exemptions", force: :cascade do |t|
    t.string   "code"
    t.string   "summary"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "flood_risk_engine_locations", force: :cascade do |t|
    t.integer  "address_id"
    t.float    "easting"
    t.float    "northing"
    t.string   "grid_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "flood_risk_engine_locations", ["address_id"], name: "index_flood_risk_engine_locations_on_address_id", using: :btree

  create_table "flood_risk_engine_organisations", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "contact_id"
    t.string   "company_number"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "flood_risk_engine_organisations", ["contact_id"], name: "index_flood_risk_engine_organisations_on_contact_id", using: :btree
  add_index "flood_risk_engine_organisations", ["type"], name: "index_flood_risk_engine_organisations_on_type", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "user_versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "user_versions", ["item_type", "item_id"], name: "index_user_versions_on_item_type_and_item_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                  default: 0
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token"
    t.text     "disabled_comment"
    t.datetime "disabled_at"
    t.datetime "locked_at"
    t.string   "role_names"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "flood_risk_engine_addresses", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "flood_risk_engine_contacts", "flood_risk_engine_organisations", column: "partnership_organisation_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_addresses", column: "site_address_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_contacts", column: "applicant_contact_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_organisations", column: "organisation_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_enrollments", column: "enrollment_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_exemptions", column: "exemption_id"
  add_foreign_key "flood_risk_engine_locations", "flood_risk_engine_addresses", column: "address_id"
  add_foreign_key "flood_risk_engine_organisations", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end

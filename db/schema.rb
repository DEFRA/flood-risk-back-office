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

ActiveRecord::Schema.define(version: 20160615130330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enrollment_exports", force: :cascade do |t|
    t.date     "from_date",                null: false
    t.date     "to_date",                  null: false
    t.string   "created_by",               null: false
    t.string   "file_name",                null: false
    t.integer  "state",        default: 0, null: false
    t.text     "failure_text"
    t.integer  "record_count"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "enrollment_exports", ["created_at"], name: "index_enrollment_exports_on_created_at", using: :btree
  add_index "enrollment_exports", ["file_name"], name: "index_enrollment_exports_on_file_name", unique: true, using: :btree

  create_table "flood_risk_engine_address_searches", force: :cascade do |t|
    t.integer  "enrollment_id", null: false
    t.string   "postcode"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "flood_risk_engine_address_searches", ["enrollment_id"], name: "index_flood_risk_engine_address_searches_on_enrollment_id", using: :btree

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
    t.date     "state_date"
    t.string   "blpu_state_code"
    t.string   "postal_address_code"
    t.string   "logical_status_code"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "uprn"
    t.string   "token"
  end

  add_index "flood_risk_engine_addresses", ["addressable_id", "addressable_type"], name: "by_addressable", using: :btree
  add_index "flood_risk_engine_addresses", ["token"], name: "index_flood_risk_engine_addresses_on_token", unique: true, using: :btree
  add_index "flood_risk_engine_addresses", ["uprn"], name: "index_flood_risk_engine_addresses_on_uprn", using: :btree

  create_table "flood_risk_engine_contacts", force: :cascade do |t|
    t.integer  "contact_type",                            default: 0,  null: false
    t.integer  "title",                                   default: 0,  null: false
    t.string   "suffix"
    t.date     "date_of_birth"
    t.string   "position",                    limit: 255
    t.string   "email_address"
    t.string   "telephone_number"
    t.integer  "partnership_organisation_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "full_name",                   limit: 255, default: "", null: false
  end

  add_index "flood_risk_engine_contacts", ["email_address"], name: "index_flood_risk_engine_contacts_on_email_address", using: :btree
  add_index "flood_risk_engine_contacts", ["full_name"], name: "index_flood_risk_engine_contacts_on_full_name", using: :btree
  add_index "flood_risk_engine_contacts", ["partnership_organisation_id"], name: "fre_contacts_partnership_organisation_id", using: :btree

  create_table "flood_risk_engine_enrollments", force: :cascade do |t|
    t.integer  "applicant_contact_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "organisation_id"
    t.string   "step",                      limit: 50
    t.integer  "correspondence_contact_id"
    t.string   "token"
    t.integer  "secondary_contact_id"
    t.string   "reference_number",          limit: 12
    t.integer  "status",                               default: 0, null: false
    t.integer  "updated_by_user_id"
  end

  add_index "flood_risk_engine_enrollments", ["applicant_contact_id"], name: "index_flood_risk_engine_enrollments_on_applicant_contact_id", using: :btree
  add_index "flood_risk_engine_enrollments", ["correspondence_contact_id"], name: "fre_enrollments_correspondence_contact_id", using: :btree
  add_index "flood_risk_engine_enrollments", ["organisation_id"], name: "index_flood_risk_engine_enrollments_on_organisation_id", using: :btree
  add_index "flood_risk_engine_enrollments", ["reference_number"], name: "index_flood_risk_engine_enrollments_on_reference_number", unique: true, using: :btree
  add_index "flood_risk_engine_enrollments", ["token"], name: "index_flood_risk_engine_enrollments_on_token", unique: true, using: :btree
  add_index "flood_risk_engine_enrollments", ["updated_by_user_id"], name: "index_flood_risk_engine_enrollments_on_updated_by_user_id", using: :btree

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
    t.integer  "code_number"
  end

  add_index "flood_risk_engine_exemptions", ["code_number"], name: "index_flood_risk_engine_exemptions_on_code_number", using: :btree

  create_table "flood_risk_engine_locations", force: :cascade do |t|
    t.string   "easting"
    t.string   "northing"
    t.string   "grid_reference"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.text     "description"
    t.string   "dredging_length"
  end

  add_index "flood_risk_engine_locations", ["locatable_id", "locatable_type"], name: "by_locatable", using: :btree

  create_table "flood_risk_engine_organisations", force: :cascade do |t|
    t.string   "name"
    t.integer  "contact_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "org_type"
    t.string   "registration_number", limit: 12
  end

  add_index "flood_risk_engine_organisations", ["contact_id"], name: "index_flood_risk_engine_organisations_on_contact_id", using: :btree
  add_index "flood_risk_engine_organisations", ["org_type"], name: "index_flood_risk_engine_organisations_on_org_type", using: :btree
  add_index "flood_risk_engine_organisations", ["registration_number"], name: "index_flood_risk_engine_organisations_on_registration_number", using: :btree

  create_table "flood_risk_engine_partners", force: :cascade do |t|
    t.integer  "organisation_id"
    t.integer  "contact_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "flood_risk_engine_partners", ["contact_id"], name: "index_flood_risk_engine_partners_on_contact_id", using: :btree
  add_index "flood_risk_engine_partners", ["organisation_id"], name: "index_flood_risk_engine_partners_on_organisation_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

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

  add_foreign_key "flood_risk_engine_address_searches", "flood_risk_engine_enrollments", column: "enrollment_id"
  add_foreign_key "flood_risk_engine_contacts", "flood_risk_engine_organisations", column: "partnership_organisation_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_contacts", column: "applicant_contact_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_contacts", column: "secondary_contact_id"
  add_foreign_key "flood_risk_engine_enrollments", "flood_risk_engine_organisations", column: "organisation_id"
  add_foreign_key "flood_risk_engine_enrollments", "users", column: "updated_by_user_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_enrollments", column: "enrollment_id"
  add_foreign_key "flood_risk_engine_enrollments_exemptions", "flood_risk_engine_exemptions", column: "exemption_id"
  add_foreign_key "flood_risk_engine_organisations", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "flood_risk_engine_partners", "flood_risk_engine_contacts", column: "contact_id"
  add_foreign_key "flood_risk_engine_partners", "flood_risk_engine_organisations", column: "organisation_id"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end

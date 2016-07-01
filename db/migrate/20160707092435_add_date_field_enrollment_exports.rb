class AddDateFieldEnrollmentExports < ActiveRecord::Migration
  def change
    add_column :enrollment_exports, :date_field_scope, :integer, default: 0
  end
end

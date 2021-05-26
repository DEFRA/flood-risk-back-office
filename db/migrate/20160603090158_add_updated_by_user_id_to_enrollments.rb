class AddUpdatedByUserIdToEnrollments < ActiveRecord::Migration[4.2]
  def change
    add_column :flood_risk_engine_enrollments, :updated_by_user_id, :integer
    add_index :flood_risk_engine_enrollments, :updated_by_user_id
    add_foreign_key :flood_risk_engine_enrollments, :users, column: :updated_by_user_id
  end
end

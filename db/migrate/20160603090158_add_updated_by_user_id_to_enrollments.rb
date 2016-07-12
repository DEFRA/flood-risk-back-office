class AddUpdatedByUserIdToEnrollments < ActiveRecord::Migration
  def change
    add_foreign_key :flood_risk_engine_enrollments, :users, column: :updated_by_user_id
  end
end

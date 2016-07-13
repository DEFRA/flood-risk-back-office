class AddMissingBackOfficeIndexes < ActiveRecord::Migration
  def change
    add_index :users, [:invited_by_id, :invited_by_type]
    add_index(
      :flood_risk_engine_enrollments_exemptions,
      :accept_reject_decision_user_id,
      name: :by_change_user
    )
  end
end

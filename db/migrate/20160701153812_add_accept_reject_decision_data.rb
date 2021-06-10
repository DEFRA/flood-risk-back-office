class AddAcceptRejectDecisionData < ActiveRecord::Migration[4.2]

  def change
    add_column :flood_risk_engine_enrollments_exemptions, :accept_reject_decision_user_id, :integer, index: true
    add_column :flood_risk_engine_enrollments_exemptions, :accept_reject_decision_at, :datetime, index: true
  end

end

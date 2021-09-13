class SecondaryContact < ActiveRecord::Base
  self.table_name = "flood_risk_engine_contacts"

  validates :email_address, "defra_ruby/validators/email": true, if: ->(obj) { obj.email_address.present? }
end

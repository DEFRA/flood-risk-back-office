class CorrespondenceContact < ActiveRecord::Base
  self.table_name = "flood_risk_engine_contacts"

  validates :full_name, presence: true
  validates :telephone_number, presence: true
  validates :email_address, presence: true
  validates :email_address, "defra_ruby/validators/email": true
end

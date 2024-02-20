class Address < ActiveRecord::Base
  self.table_name = "flood_risk_engine_addresses"

  validates :premises, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :postcode, "defra_ruby/validators/postcode": true

  def to_param
    token
  end
end

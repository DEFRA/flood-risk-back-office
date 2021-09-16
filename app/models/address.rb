class Address < ActiveRecord::Base
  self.table_name = "flood_risk_engine_addresses"

  validates :premises, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :postcode, presence: true
  validates :postcode, length: { maximum: 8 }

  def to_param
    token
  end

  def address_finder_errored!
    # Invoked by postcode validator, but we don't want/need it here
  end
end

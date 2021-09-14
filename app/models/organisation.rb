class Organisation < ActiveRecord::Base
  self.table_name = "flood_risk_engine_organisations"

  validates :name, presence: true
end

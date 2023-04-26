require "rails_helper"

module FloodRiskEngine
  RSpec.describe Enrollment do
    it { is_expected.to respond_to :updated_by_user_id }
  end
end

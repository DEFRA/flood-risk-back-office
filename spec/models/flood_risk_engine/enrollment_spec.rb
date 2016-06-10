require "rails_helper"

module FloodRiskEngine
  RSpec.describe Enrollment, type: :model do
    it { is_expected.to respond_to :updated_by_user_id }
  end
end

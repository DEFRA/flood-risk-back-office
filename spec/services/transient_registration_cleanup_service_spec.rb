# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationCleanupService do
  describe ".run" do
    let(:transient_registration) { create(:new_registration, :has_required_data_for_limited_company) }
    let(:id) { transient_registration.id }

    context "when a transient_registration is older than 30 days" do
      before do
        transient_registration.update!(created_at: Time.now - 31.days)
      end

      it "deletes it" do
        expect { described_class.run }.to change { FloodRiskEngine::TransientRegistration.where(id: id).count }.from(1).to(0)
      end

      it "deletes its transient_addresses" do
        address_id = transient_registration.company_address.id

        expect { described_class.run }.to change { FloodRiskEngine::TransientAddress.where(id: address_id).count }.from(1).to(0)
      end

      context "when there are transient_people" do
        let(:transient_registration) { create(:new_registration, :has_required_data_for_partnership) }

        it "deletes its transient_people" do
          people_count = transient_registration.transient_people.count

          expect { described_class.run }.to change { FloodRiskEngine::TransientPerson.where(transient_registration_id: id).count }.from(people_count).to(0)
        end
      end

      it "deletes its transient_registration_exemptions" do
        re_count = transient_registration.transient_registration_exemptions.count

        expect { described_class.run }.to change { FloodRiskEngine::TransientRegistrationExemption.where(transient_registration_id: id).count }.from(re_count).to(0)
      end
    end

    context "when a transient_registration is newer than 30 days" do
      it "does not delete it" do
        expect { described_class.run }.to_not change { FloodRiskEngine::TransientRegistration.where(id: id).count }.from(1)
      end
    end
  end
end

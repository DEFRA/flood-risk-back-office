require "rails_helper"

RSpec.describe EnrollmentExemption do
  describe ".status_keys" do
    it "retrieves the expected status_keys" do
      expect(described_class.status_keys).to eq(
        %w[pending being_processed approved rejected expired withdrawn deregistered]
      )
    end
  end

  describe "validations" do
    subject { enrollment_exemption.valid? }

    let(:enrollment_exemption) { EnrollmentExemption.new(commentable: true) }

    it "validates the comment_content length" do
      enrollment_exemption.comment_content = ("foo" * 200)

      subject

      expect(enrollment_exemption.errors).to include(:comment_content)
    end
  end

  describe "#action!" do
    subject { enrollment_exemption.action!(params) }

    let(:flood_risk_engine_enrollment_exemption_id) do
      create(:submitted_limited_company).enrollment_exemptions.first.id
    end

    let(:enrollment_exemption) do
      EnrollmentExemption.find(flood_risk_engine_enrollment_exemption_id)
    end

    context "with a change in status" do
      let(:params) { { status: :approved } }

      it "requires a comment" do
        subject

        expect(enrollment_exemption.errors).to include(:comment_content)
      end

      context "and a comment" do
        let(:user) { create(:user) }
        let(:comment) { enrollment_exemption.reload.comments.last }

        before do
          params.merge!(
            {
              comment_content: "Hola!",
              comment_event: "Approved",
              comment_user_id: user.id
            }
          )

          subject
        end

        it "creates a comment" do
          expect(comment.content).to eq("Hola!")
          expect(comment.event).to eq("Approved")
          expect(comment.user).to eq(user)
        end

        it "updates the status" do
          expect(enrollment_exemption.reload).to be_approved
        end
      end
    end
  end
end

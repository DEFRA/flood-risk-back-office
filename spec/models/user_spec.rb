require "rails_helper"

RSpec.describe User do
  let(:user) { create(:user) }

  describe "#disable" do
    it "updates the disabled_at and disabled_comment attributes" do
      comment = "test comment"
      user.disable(comment)
      expect(user.disabled_at).not_to be_nil
      expect(user.disabled_comment).to eq(comment)
    end
  end

  describe "#disable!" do
    it "updates the disabled_at and disabled_comment attributes and saves the record" do
      comment = "test comment"
      user.disable!(comment)
      expect(user.disabled_at).not_to be_nil
      expect(user.disabled_comment).to eq(comment)
      expect(user.reload.disabled_at).not_to be_nil
      expect(user.reload.disabled_comment).to eq(comment)
    end
  end

  describe "#enable!" do
    it "clears the disabled_at and disabled_comment attributes and saves the record" do
      user.disable!("test comment")
      user.enable!
      expect(user.disabled_at).to be_nil
      expect(user.disabled_comment).to be_nil
      expect(user.reload.disabled_at).to be_nil
      expect(user.reload.disabled_comment).to be_nil
    end
  end

  describe "#disabled?" do
    it "returns true if the user is disabled" do
      user.disable!("test comment")
      expect(user).to be_disabled
    end

    it "returns false if the user is not disabled" do
      expect(user).not_to be_disabled
    end
  end

  describe "#enabled?" do
    it "returns true if the user is enabled" do
      expect(user).to be_enabled
    end

    it "returns false if the user is disabled" do
      user.disable!("test comment")
      expect(user).not_to be_enabled
    end
  end

  describe "#password_meets_minimum_requirements" do
    it "validates that the password meets the minimum length requirements" do
      user.password = "pass"
      user.password_confirmation = "pass"
      expect(user).not_to be_valid
      expect(user.errors[:password].first).to include("must be at least 8 characters")
    end

    it "validates that the password meets the minimum strength requirements" do
      user.password = "password"
      user.password_confirmation = "password"
      expect(user).not_to be_valid
      expect(user.errors[:password].first).to include("at least one uppercase character, one lowercase character and one number")
    end
  end

  describe "#email" do
    it "validates the length of the email" do
      user.email = "a" * 256
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end
  end

  describe "#add_to_role_names" do
    let(:role) { Role.new(name: "foo") }

    it "adds the role" do
      user.add_to_role_names(role)
      expect(user.role_names).to include role.name
    end
  end

  describe "#remove_from_role_names" do
    let(:role) { Role.new(name: "foo") }

    it "removes the role" do
      user.add_to_role_names(role)
      expect(user.role_names).to include role.name

      user.remove_from_role_names(role)
      expect(user.role_names).to be_nil
    end
  end

  describe "#send_devise_notification" do
    subject(:send_notification) { user.send_devise_notification(:reset_password_instructions) }

    context "when not using inline queue" do
      let(:delivery_job) { instance_double(ActionMailer::MailDeliveryJob) }

      before do
        allow(Rails.application.config.active_job).to receive(:queue_adapter).and_return(:sucker_punch)
        allow(ActionMailer::MailDeliveryJob).to receive(:new).and_return delivery_job
        allow(delivery_job).to receive(:enqueue)
      end

      it { expect { send_notification }.not_to raise_error }
    end
  end
end

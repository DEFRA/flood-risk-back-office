# frozen_string_literal: true

require "rails_helper"
require "notifications/client"

RSpec.describe NotifyMail do
  subject(:instance) { described_class.new(settings) }

  let(:settings) { { api_key: "abcde987654321" } }
  let(:response) { { id: "123456789" } }
  let(:client) { instance_double(Notifications::Client, send_email: response) }

  describe "#deliver!" do
    let(:mail) do
      {
        to: "radi.perlman@example.com",
        template_id: "1234567890",
        personalisation: { unparsed_value: { name: "Radia Perlman", environment: "test" } }
      }
    end

    before { allow(Notifications::Client).to receive(:new) { client } }

    context "when no errors occur" do
      it "forwards the mail message to Notify" do
        expect(client).to receive(:send_email).with(
          {
            email_address: "radi.perlman@example.com",
            template_id: "1234567890",
            personalisation: { name: "Radia Perlman", environment: "test" }
          }
        )
        instance.deliver!(mail)
      end

      it "logs the response" do
        expect(Rails.logger).to receive(:info).with(response.to_json)

        instance.deliver!(mail)
      end

      it "adds the response to the mail object" do
        instance.deliver!(mail)

        expect(mail[:response]).to eq(response.to_json)
      end
    end

    context "when an error occurs" do
      let(:error) { StandardError.new("boom") }

      before { allow(client).to receive(:send_email).and_raise(error) }

      it "throws the error up (doesn't squash it)" do
        expect { instance.deliver!(mail) }.to raise_error(UncaughtThrowError)
      end

      it "logs the response" do
        expect(Rails.logger).to receive(:error).with(error)

        expect { instance.deliver!(mail) }.to raise_error(UncaughtThrowError)
      end
    end
  end
end

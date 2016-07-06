# encoding: UTF-8
require "rails_helper"

RSpec.describe RegistrationApprovedMailer, type: :mailer do
  def t(key)
    I18n.t(key, scope: mail_yaml_key)
  end

  describe "approval email" do
    let(:recipient_address) { ["test@example.com"] }

    # Note the enrollment is set in each per organisation section below - using factory suitable for that Org Type

    let(:mail) do
      ee = @enrollment.enrollment_exemptions.first
      described_class.approved(enrollment_exemption: ee, recipient_address: recipient_address)
    end

    let(:mail_yaml_key) { described_class.mail_yaml_key }

    shared_examples_for "an approval email" do |encoder_lambda|
      let(:encoder) { encoder_lambda }

      it "renders the subject" do
        expect(mail.subject).to_not match(/translation missing/)
        expect(mail.subject).to eql(I18n.t("#{mail_yaml_key}.subject"))
      end

      it "has the receiver's email" do
        expect(mail.to).to eql(recipient_address)
      end

      it "has the sender's email" do
        expect(ENV["DEVISE_MAILER_SENDER"]).to_not be_blank
        # Need to extract email part of sender address from entries like:
        #   "No reply <no-reply@environment-agency.gov.uk>"
        email_pattern = /[\w\-\.]+@[\w\-\.]+/
        email = ENV["DEVISE_MAILER_SENDER"][email_pattern]
        expect(mail.from).to eql([email])
      end

      describe "content" do
        subject { body }

        let(:type) { @enrollment.organisation.org_type }

        it { is_expected.to_not have_body_text(/translation missing/) }

        context "'Registration details'" do
          let(:yaml_scope) { "confirmation_email.sections.registration_details.associations" }

          describe "#Reference number" do
            let(:value) { @enrollment.reference_number }
            it { is_expected.to have_body_text(encoder.call(value)) }
          end
        end

        context "'Your contact details'" do
          describe "full name" do
            let(:value) { @enrollment.correspondence_contact.full_name }
            it { is_expected.to have_body_text(encoder.call(value)) }
          end

          describe "telephone" do
            let(:value) { @enrollment.correspondence_contact.telephone_number }
            it { is_expected.to have_body_text(encoder.call(value)) }
          end

          describe "email" do
            let(:value) { @enrollment.correspondence_contact.email_address }
            it { is_expected.to have_body_text(encoder.call(value)) }
          end

          describe "address", duff: true do
            it {
              address = if type == "partnership"
                          @enrollment.organisation.partners.first.address
                        else
                          @enrollment.organisation.primary_address
                        end

              is_expected.to have_body_text(encoder.call(address.premises))
              is_expected.to have_body_text(encoder.call(address.street_address))
              is_expected.to have_body_text(encoder.call(address.city))
              is_expected.to have_body_text(encoder.call(address.postcode))
            }
          end
        end

        context "EnrollmentExemption" do
          describe "exemption" do
            # code: "FRA_RSPEC_47", summary: "Sleek Copper Clock", description:
            let(:value) { @enrollment.exemptions.first }
            it { is_expected.to have_body_text(encoder.call(value.code)) }
            it { is_expected.to have_body_text(encoder.call(value.summary)) }
          end

          describe "grid reference" do
            let(:value) { @enrollment.exemption_location }
            it { is_expected.to have_body_text(encoder.call(value.grid_reference)) }
          end
        end
      end
    end

    FloodRiskEngine::Organisation.org_types.keys.each do |ot|
      next if ot.to_sym == :unknown

      context "#{ot.humanize.capitalize} organisation" do
        before(:each) do
          @enrollment = create(:"approved_#{ot}")
        end

        # Note we used to pass in a lambda to the shared example to cope with
        # the fact that single quotes would be encoded - appling the encoder let us check the escaped
        # value existsed in the body text, e.g.
        #   it_behaves_like "a confirmation email", ->(value) { value } do ..
        # However since upgrading to rails 4.2.5.1 this seems to no longer be required.
        describe "html version" do
          it_behaves_like "an approval email", ->(value) { value } do
            let(:body) { mail.html_part }
          end
        end

        describe "text version" do
          it_behaves_like "an approval email", ->(value) { value } do
            let(:body) { mail.text_part }
          end
        end
      end
    end
  end
end

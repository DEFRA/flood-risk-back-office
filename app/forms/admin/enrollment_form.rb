module Admin
  class EnrollmentForm < BaseForm

    def params_key
      :admin_enrollment
    end

    def self.locale_key
      "admin.enrollments".freeze
    end

    alias enrollment model

    def enrollment_exemption
      enrollment.enrollment_exemptions.first
    end

    property :organisation_name, virtual: true
    property :correspondence_contact_full_name, virtual: true
    property :correspondence_contact_position, virtual: true
    property :correspondence_contact_telephone_number, virtual: true
    property :correspondence_contact_email_address, virtual: true
    property :secondary_contact_email_address, virtual: true

    delegate(
      :organisation, :correspondence_contact, :reference_number,
      to: :enrollment
    )

    delegate :name, :name=, to: :organisation, prefix: true
    delegate(
      :email_address, :email_address=,
      :position, :position=,
      :telephone_number, :telephone_number=,
      :full_name, :full_name=,
      to: :correspondence_contact,
      prefix: true
    )

    def secondary_contact
      @secondary_contact ||= enrollment.secondary_contact || enrollment.secondary_contact.build
    end
    delegate :email_address, :email_address=, to: :secondary_contact, prefix: true

    validates(
      :organisation_name,
      presence: { message: t(".errors.organisation_name.blank") }
    )

    validates(
      :correspondence_contact_full_name,
      presence: { message: t(".errors.correspondence_contact_full_name.blank") }
    )

    validates(
      :correspondence_contact_telephone_number,
      phone: {
        message: t(".errors.correspondence_contact_telephone_number.invalid"),
        allow_blank: true
      },
      presence: {
        message: t(".errors.correspondence_contact_telephone_number.blank")
      }
    )

    validates(
      :correspondence_contact_email_address,
      presence: {
        message: t(".errors.email_address.blank", contact: :correspondence)
      },
      email_format: {
        allow_blank: true,
        message: t(".errors.email_address.format", contact: :correspondence)
      }
    )

    validates(
      :secondary_contact_email_address,
      email_format: {
        allow_blank: true,
        message: t(".errors.email_address.format", contact: :secondary)
      }
    )

    def save
      enrollment.transaction do
        organisation.save!
        correspondence_contact.save!
        secondary_contact.save! if secondary_contact_email_address.present?
        super
      end
    end

  end
end

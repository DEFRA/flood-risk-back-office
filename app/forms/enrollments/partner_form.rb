module Enrollments
  class PartnerForm < AddressForm

    def self.t(locale, args = {})
      I18n.t "enrollments.partners#{locale}", args
    end

    attr_reader :partner, :contact

    def initialize(enrollment, partner)
      @partner = partner
      @contact = partner.contact
      super(enrollment, partner.address)
    end

    def self.max_length
      70
    end

    property :full_name, virtual: true
    validates(
      :full_name,
      presence: {
        message: t(".errors.full_name.blank")
      },
      "flood_risk_engine/text_field_content" => {
        allow_blank: true
      },
      length: {
        maximum: max_length,
        message: t(".errors.full_name.too_long", max: max_length)
      }
    )

    def full_name
      super || contact.full_name
    end

    def save
      enrollment.transaction do
        super
        contact.full_name = full_name
        contact.save!
      end
    end
  end
end

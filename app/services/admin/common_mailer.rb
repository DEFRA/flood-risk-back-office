require "flood_risk_engine/exceptions"

module Admin
  module CommonMailer

    def distinct_recipients
      [primary_contact_email, secondary_contact_email]
        .select(&:present?)
        .map(&:strip)
        .map(&:downcase)
        .uniq
    end

    def primary_contact_email
      enrollment.correspondence_contact.try :email_address
    end

    def secondary_contact_email
      enrollment.secondary_contact.try :email_address
    end

  end
end

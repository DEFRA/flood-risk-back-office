# A generalised presenter which simplifies accessing enrollment data in Email templates
#
class ExemptionEmailPresenter

  include ActionView::Helpers::TagHelper

  delegate :enrollment,
           :exemption,
           :accept_reject_decision_at,
           to: :enrollment_exemption

  delegate :correspondence_contact,
           :exemption_location,
           :organisation,
           :reference_number,
           to: :enrollment

  delegate :full_name,
           :email_address,
           :telephone_number,
           :position,
           to: :correspondence_contact, allow_nil: true

  delegate :grid_reference,
           to: :exemption_location, allow_nil: true

  delegate :name, :primary_address, :partners, to: :organisation, allow_nil: true

  def initialize(enrollment_exemption)
    @enrollment_exemption = enrollment_exemption
  end

  def exemption_title
    exemption.summary
  end

  def partnership?
    organisation.try(&:partnership?)
  end

  # For partnerships there's no organisation name
  def organisation_name
    return if partnership?

    organisation.name
  end

  def address_parts_for_email(address)
    return unless address

    # join house number and street address, rest as separate elements
    street_lne = [address.premises, address.street_address].reject(&:blank?).join(", ")

    parts = [street_lne, address.locality, address.city, address.postcode]

    parts.reject(&:blank?)
  end

  # Just 'code' in the view does not give much context so prefer a longer more meaningful name
  def exemption_code
    exemption.code
  end

  def asset?
    enrollment_exemption.asset_found?
  end

  def salmonid?
    enrollment_exemption.salmonid_river_found?
  end

  def decision_date
    ldate(accept_reject_decision_at, format: :long)
  end

  private

  attr_reader :enrollment_exemption

  def ldate(date, **hash)
    date ? I18n.l(date, **hash) : nil
  end

end

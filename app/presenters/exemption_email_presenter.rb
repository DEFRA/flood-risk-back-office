# A generalised presenter which simplifies accessing enrollment data in Email templates
#
class ExemptionEmailPresenter

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

  delegate :name,
           :primary_address,
           to: :organisation, allow_nil: true

  def initialize(enrollment_exemption)
    @enrollment_exemption = enrollment_exemption
  end

  def exemption_title
    exemption.summary
  end

  # Just 'code' in the view does not give much context so prefer a longer more meaningful name
  # rubocop:disable Rails/Delegate
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

  def ldate(dt, hash = {})
    dt ? I18n.l(dt, hash) : nil
  end

end

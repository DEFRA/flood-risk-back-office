# frozen_string_literal: true

class FormatOrganisationAddressService < FloodRiskEngine::BaseService
  def run(organisation:, separator:)
    @organisation = organisation
    @separator = separator

    @organisation.partnership? ? format_partnership_address : format_address
  end

  private

  def format_partnership_address
    @organisation.partners.map do |partner|
      [partner.full_name] + address_parts(partner.address)
    end.join(@separator).to_s
  end

  def format_address
    (
      [@organisation.name] + address_parts(@organisation.primary_address)
    ).join(@separator).to_s
  end

  def address_parts(address)
    [
      [address.premises, address.street_address].reject(&:blank?).join(", "),
      address.locality,
      address.city,
      address.postcode
    ].reject(&:blank?)
  end
end

# The PartnerAddress supports editing the Full Name and Address
# It should only be used when the #addressable class is a Contact.
class PartnerAddress < Address
  belongs_to :addressable, polymorphic: true

  validates :full_name, presence: true

  before_save :update_full_name

  def full_name
    addressable.full_name if contact_address?
  end

  def full_name=(val)
    addressable.full_name = val if contact_address?
  end

  private

  def update_full_name
    addressable.save if contact_address?
  end

  def contact_address?
    addressable.is_a?(FloodRiskEngine::Contact)
  end
end

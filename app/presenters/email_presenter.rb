# A generalised presenter which simplifies accessing enrollment data in Email templates
#
class EmailPresenter

  delegate :reference_number, to: :enrollment

  def initialize(enrollment)
    @enrollment = enrollment
  end

  private

  attr_reader :enrollment
end

class EnrollmentExemptionsPresenter < Presenter
  attr_reader :enrollment_exemptions # , :search_params

  delegate :num_pages,
           :current_page,
           :total_pages,
           :limit_value, to: :enrollment_exemptions

  def initialize(enrollment_exemptions, view_context)
    @enrollment_exemptions = enrollment_exemptions
    super(view_context)
  end

  # Helper iterator to allow a view to iterate over enrollment_exemptions using an
  # EnrollmentExemptionPresenter eg when building a table
  def each_enrollment_exemption
    enrollment_exemptions.each do |ee|
      presenter = EnrollmentExemptionPresenter.new(ee, view_context)
      yield(presenter)
    end
  end
end

class SearchForm
  include ActiveModel::Model
  STATUS_ALL = nil

  attr_reader :q, :status, :page, :per_page
  delegate :model_name, to: FloodRiskEngine::EnrollmentExemption

  # Note that params[:search] are the fields in the search html form.
  # Kaminari params :page and :per_page are at the top level in the params.
  def initialize(params)
    form_params = params.fetch(:search, {})

    @q = form_params.fetch(:q, "").strip
    @status = form_params.fetch(:status, STATUS_ALL)
    @page = params.fetch(:page, 1)
    @per_page = params.fetch(:per_page, 20)
  end

  def status_filter_options
    FloodRiskEngine::EnrollmentExemption.statuses.map(&:first)
  end

  def empty?
    status.blank? && q.blank?
  end
end

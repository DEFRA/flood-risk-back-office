class SearchForm
  attr_reader :q, :state, :page, :per_page

  def initialize(params = {})
    @q = params.fetch(:q, "")
    @state = params.fetch(:state, "pending")
    @page = params.fetch(:page, 1)
    @per_page = params.fetch(:page, 10)
  end
end

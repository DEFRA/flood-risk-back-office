class EnrollmentSearch < ActiveRecord::Base
  extend Textacular
  self.table_name = "dsc_enrollment_searches" # This is a database view

  belongs_to :enrollment, class_name: "FloodRiskEngine::Enrollment"

  attr_accessor :q

  def self.searchable_language
    "simple"
  end

  def self.prefixed_any_search(term)
    return none if term.blank?

    # 1. Remove out all characters that are not:
    #   Whitespace
    #   Unicode alpha-numeric
    #   @, ., -, _ (for email address)
    #   keywords: and or not
    query = term
            .gsub(/[^\.\-_@[[:space:]][[:alnum:]]]/, " ")
            .gsub(/ and /i, " ").gsub(/ or /i, " ").gsub(/ not /i, " ")

    return none if query.blank?

    # 2. Split into a white-space separated array
    # 3. Convert to a postgres text search (prefix-matched with OR (|) operator)
    #    (see http://www.postgresql.org/docs/9.2/static/datatype-textsearch.html)
    # 4. Sanitize the query to avoid SQL injection
    query = query.squish.split(/[[:space:]]/).map { |str| "#{str}:*" }.join("|")

    advanced_search sanitize_sql(query)
  end

  private

  # this isn't strictly necessary, but it will prevent
  # rails from calling save, which would fail anyway.
  def readonly?
    true
  end
end

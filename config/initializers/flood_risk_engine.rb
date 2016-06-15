FloodRiskEngine.configure do |config|
  # By de3fault we use a different layout to the host app (ie we don't use application by default)
  # because that layout may include calls to helper methods that we (as an isolated engine)
  # don;t have access to.
  config.layout = "flood_risk_engine"
  config.redirection_url_on_location_unchecked = "http://gov.uk"
end

export_directory = Rails.root.join("private", "exports")

FileUtils.mkdir_p(export_directory) unless File.directory?(export_directory)

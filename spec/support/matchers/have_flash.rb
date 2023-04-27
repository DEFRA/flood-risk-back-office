RSpec::Matchers.define :have_flash do |text|
  match do
    expect(page).to have_css(".govuk-notification-banner", text:)
  end
end

RSpec::Matchers.define :have_no_flash do
  match do
    expect(page).not_to have_css alert_css(".govuk-notification-banner")
  end
end

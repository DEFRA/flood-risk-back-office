RSpec::Matchers.define :have_flash do |text, key: :notice|
  match do |_actual|
    expect(page).to have_css(alert_css(key), text: text)
  end

  failure_message do |_actual|
    %(expected to see a HTML element [#{alert_css key}], with text "#{text}")
  end

  failure_message_when_negated do |_actual|
    %(expected not to see a HTML element [#{alert_css key}], with text "#{text}")
  end

  description do
    %(display a HTML element [#{alert_css key}], with text "#{text}")
  end

  private

  def alert_css(key)
    # Map flash keys to Bootstrap CSS classes
    clazz =
      case key
      when :alert then "danger"
      when :notice then "success"
      when :info then "info"
      when :warn then "warning"
      when :not_authorized then "danger"
      else "alert"
      end

    ".alert.alert-#{clazz}"
  end
end

RSpec::Matchers.define :have_no_flash do |key = :notice|
  match do |_actual|
    expect(page).to have_no_css alert_css(key)
  end

  failure_message do |_actual|
    %(expected not to see a HTML element [#{alert_css key}])
  end

  failure_message_when_negated do |_actual|
    %(expected to see a HTML element [#{alert_css key}])
  end

  description do
    %(not display a HTML element [#{alert_css key}])
  end

  private

  def alert_css(key)
    # Map flash keys to Bootstrap CSS classes
    clazz =
      case key
      when :alert then "danger"
      when :notice then "success"
      when :info then "info"
      when :warn then "warning"
      when :not_authorized then "danger"
      else "alert"
      end

    ".alert.alert-#{clazz}"
  end
end

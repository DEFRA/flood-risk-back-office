error_css_suffix = ".form-group.has-error .help-block"

RSpec::Matchers.define :have_form_error do |selector, text: nil, count: 1|
  selector = ".#{selector}" if selector.is_a?(Symbol)
  error_css = "#{selector}#{error_css_suffix}"

  match do |actual|
    expect(actual).to have_css(error_css, text: text, count: count)
  end

  failure_message do |_actual|
    "expected to see HTML element(s) [#{error_css}], with text \"#{text}\" " \
    "(count: #{count})"
  end

  failure_message_when_negated do |_actual|
    "expected not to see HTML element(s) [#{error_css}], with text \"#{text}\" " \
    "(count: #{count})"
  end

  description do
    %{display HTML element(s) [#{error_css}], with text "#{text}" (count: #{count})}
  end
end

RSpec::Matchers.define :have_no_form_error do |selector, text|
  selector = ".#{selector}" if selector.is_a?(Symbol)
  error_css = "#{selector}#{error_css_suffix}"

  match do |actual|
    expect(actual).to have_no_css(error_css, text: text)
  end

  failure_message do |_actual|
    %(expected NOT to see a HTML element [#{error_css}], with text "#{text}")
  end

  failure_message_when_negated do |_actual|
    %(expected to see a HTML element [#{error_css}], with text "#{text}")
  end

  description do
    %(NOT display a HTML element [#{error_css}], with text "#{text}")
  end
end

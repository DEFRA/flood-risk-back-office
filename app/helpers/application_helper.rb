module ApplicationHelper
  def full_devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.messages.values.compact.map(&:to_sentence)

    render "shared/validation_errors", messages: messages
  end
end

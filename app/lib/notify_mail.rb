# frozen_string_literal: true

require "notifications/client"

##
# A custom mailer that is compatible with ActionMailer but sends emails via
# [GOV.UK Notify](https://github.com/alphagov/notifications-ruby-client) instead of SMTP
#
# By default ActionMailer and Rails assume you are sending email via SMTP. This is why you'll see the following in
# `config/environments/development.rb` and `production.rb` after a `rails new` call.
#
#   config.action_mailer.delivery_method = :notify_mail
#
# You can add you're own custom method though by creating a class with an initializer and a `deliver!(mail)` method and
# telling ActionMailer about it using using
#
#   ActionMailer::Base.add_delivery_method(:notify_mail, NotifyMail)
#   # ...
#   config.action_mailer.delivery_method = :notify_mail
#   config.action_mailer.notify_mail_settings = { api_key: ENV.fetch("NOTIFY_API_KEY")}
#
# You still create your [mailers](https://guides.rubyonrails.org/action_mailer_basics.html) as normal. Only when you
# call, for example, `UserMailer.invitation().deliver_now()` Rails will use your declared class.
#
# As GOV.UK Notify is actually a web API you could skip using ActionMailer altogether. Creating a class that knows which
# Notify template to use and forwards the necessary personalisation will get the job done. But by creating our own
# custom mailer all the other features are still available. For example, we can still configure per environment whether
# delivery errors are raised. We can also still use interceptors and observers with the emails we're sending.
class NotifyMail
  attr_accessor :settings

  def initialize(settings)
    @settings = settings
  end

  ##
  # What ActionMail calls after you call `mail()` in your `app/mailers/my_mailer.rb`
  #
  # Expects to receive a [Mail::Message](https://www.rubydoc.info/github/mikel/mail/Mail/Message) object with the
  # properties it needs set. `:to` is a standard property of a mail message but `template_id` and `personalisation`
  # are things we add within our mailer, for example, `app/mailers/user_mailer.rb`.
  def deliver!(mail)
    response = client.send_email(
      email_address: mail[:to].to_s,
      template_id: mail[:template_id].to_s,
      personalisation: mail_field_to_hash(mail[:personalisation])
    )
    # Add the response to the mail object. This means any ActionMailer observers will have access to the data in the
    # response
    mail[:response] = response.to_json
    Rails.logger.info(response.to_json)

    response
  rescue StandardError => e
    # We catch the error so we can ensure we get a notification in Errbit. But we then throw it onwards. Whether it
    # bubbles up to the UI/user is dependent on which environment is being run and its
    # `config.action_mailer.raise_delivery_errors` setting. If we swallowed it we'd make that setting meaningless.
    Rails.logger.error(e)
    throw e
  end

  private

  def client
    @_client ||= Notifications::Client.new(@settings[:api_key])
  end

  ##
  # Use to extract a value from a Mail::Field as a hash
  #
  # The properties of the `mail` object passed in to `deliver!()` are of type `Mail::Field`
  #
  # https://www.rubydoc.info/github/mikel/mail/Mail/Field
  #
  # When you call `to_s()` on the property you'll just get back the value. For Notify's personalisation argument though
  # we need an actual hash. A common approach to convert a string to a hash is to parse it using `JSON.parse()`. But
  # `to_s()` doesn't return valid JSON. So, we call `to_json()` on the field instead.
  #
  # Our problem then is we get something very different back
  #
  #   {"name":"personalisation","unparsed_value":{"name":"Luke Skywalker",
  #   "link":"http://localhost:3001/auth/password/edit?reset_password_token=q-WtfanSr4sjsDm_FB8R"},
  #   "charset":"UTF-8","field_order_id":100,"field":{"errors":[],"charset":"UTF-8",
  #   "name":"personalisation","length":null,"element":null,"value":"{:name=\u003e\"Luke Skywalker\",
  #   :link=\u003e\"http://localhost:3001/auth/password/edit?reset_password_token=q-WtfanSr4sjsDm_FB8R\"}"}}
  #
  # The property we want out of this is the `unparsed_value`. So, this method is used to extract the value of a
  # `Mail::Field` and return it as a ruby hash object. This is done by converting the field to json, then parsing it.
  # From the parsed result we extract `unparsed_value` and call `symbolize_keys()` so we get `:name` rather then
  # `"name"`.
  def mail_field_to_hash(field)
    parsed_field = JSON.parse(field.to_json)
    parsed_field["unparsed_value"].symbolize_keys
  end
end

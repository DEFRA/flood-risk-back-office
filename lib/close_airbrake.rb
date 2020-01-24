# frozen_string_literal: true

# To ensure errors are reported by Airbrake when a rake task fails we need
# to tell Airbrake to close before the exit the task. This is because
# Airbrake operates asynchronously, queuing up the notifications to send rather
# than forcing the app to wait.
#
# However there is an issue when calling `Airbrake.close` in the test
# environment. The test suite will complain about airbrake being closed already
# when running. Since there is no way in version 5.8 to ask Airbrake if it is
# already closed or to reopen it before every test, this check prevents the test
# suite from complaining.
#
# We could have just put the line `Airbrake.close unless Rails.env.test?` in
# each rake task, but we wanted to record these notes but just in one place.
class CloseAirbrake
  def self.now
    Airbrake.close unless Rails.env.test?
  end
end

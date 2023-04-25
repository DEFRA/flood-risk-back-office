
# fix for circular load dependency: https://github.com/email-spec/email-spec/issues/220
ActiveSupport.on_load(:action_mailer) do
  module EmailSpec
    module Helpers; end
  end  
  require 'email_spec'
end

module BackOfficeCore
  class PasswordsController < ::Devise::PasswordsController
    protected

    def after_sending_reset_password_instructions_path_for(_resource_name)
      back_office_core.new_user_session_path if is_navigational_format?
    end

    def after_resetting_password_path_for(resource)
      if Devise.sign_in_after_reset_password
        after_sign_in_path_for(resource)
      else
        back_office_core.new_user_session_path
      end
    end
  end
end

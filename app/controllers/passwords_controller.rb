class PasswordsController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(_resource_name)
    new_user_session_path if is_navigational_format?
  end

end

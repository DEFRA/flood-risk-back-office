module BackOfficeCore
  class UnlocksController < ::Devise::UnlocksController
    protected

    # The path used after sending unlock password instructions
    def after_sending_unlock_instructions_path_for(_resource)
      new_user_session_path if is_navigational_format?
    end

    # The path used after unlocking the resource
    def after_unlock_path_for(_resource)
      new_user_session_path if is_navigational_format?
    end
  end
end

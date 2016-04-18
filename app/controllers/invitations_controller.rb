# rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
module BackOfficeCore
  class InvitationsController < ::Devise::InvitationsController
    before_action :configure_permitted_parameters

    # Adapted from https://github.com/scambra/devise_invitable/blob/v1.5.3/app/controllers/devise/invitations_controller.rb#L39
    # TODO: refactor this!
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    def update
      raw_invitation_token = update_resource_params[:invitation_token]
      self.resource = accept_resource

      invitation_accepted = resource.errors.empty?

      yield resource if block_given?

      if invitation_accepted
        if Devise.allow_insecure_sign_in_after_accept
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message :notice, flash_message if is_flashing_format?
          sign_in(resource_name, resource)
          respond_with resource, location: after_accept_path_for(resource)
        else
          set_flash_message :notice, :updated_not_active if is_flashing_format?
          respond_with resource, location: back_office_core.new_user_session_path
        end
      else
        resource.invitation_token = raw_invitation_token
        respond_with_navigational(resource) { render :edit }
      end
    end

    protected

    # Adapted from https://github.com/scambra/devise_invitable/blob/v1.5.3/app/controllers/devise/invitations_controller.rb#L71
    def invite_resource(&block)
      resource_class.invite!(invite_params, current_inviter) do |res|
        if res.assigned_role.blank?
          res.errors.add :assigned_role, :blank
        elsif !res.assigned_role.in? I18n.t("back_office_core.allowed_roles").stringify_keys.keys
          res.errors.add :assigned_role, :inclusion
        end

        if res.errors.empty? && res.assigned_role.present?
          res.add_role res.assigned_role
        end

        # rubocop:disable Performance/RedundantBlockCall
        block.call if block
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:invite).concat [:assigned_role]
    end

    def authenticate_inviter!
      authenticate_user! force: true
      authorize DigitalServicesCore::User, :invite?
      current_user
    end

    def after_invite_path_for(_current_inviter)
      flash[:updated_user_id] = resource.id
      back_office_core.admin_users_path
    end
  end
end

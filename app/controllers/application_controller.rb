class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :skip_user_authenticate?

  after_action :verify_authorized, unless: :skip_pundit_verify?
  # TODO: reinstate - after_action :verify_policy_scoped, only: :index, unless: :skip_pundit_verify?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def signed_in_root_path(_resource_or_scope)
    main_app.root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    main_app.root_path
  end

  def high_voltage_controller?
    self.class.to_s =~ /^HighVoltage::/
  end
  helper_method :high_voltage_controller?

  def govuk_admin_template_controlller?
    self.class.to_s =~ /^GovukAdminTemplate::/
  end
  helper_method :govuk_admin_template_controlller?

  def dsc_errors_controller?
    self.class.to_s =~ /^ErrorsController/
  end
  helper_method :dsc_errors_controller?

  def skip_user_authenticate?
    devise_controller? ||
      high_voltage_controller? ||
      govuk_admin_template_controlller? ||
      dsc_errors_controller?
  end

  def skip_pundit_verify?
    devise_controller? ||
      high_voltage_controller? ||
      govuk_admin_template_controlller? ||
      dsc_errors_controller?
  end

  def user_not_authorized(exception)
    flash[:not_authorized] =
      if exception.try(:policy)
        pundit_message exception
      else
        I18n.t :default, scope: :pundit
      end

    path = main_app.root_path

    redirect_to(request.referer || path)
  end

  # rubocop:disable Metrics/AbcSize
  def pundit_message(exception)
    act = exception.query
    policy_name = exception.policy.class.to_s.underscore

    count = act.to_sym.in?(%i(index? list?)) ? 2 : 1

    model_name =
      if exception.record.is_a?(Class)
        exception.record.model_name
      else
        exception.record.class.model_name
      end

    human_name = model_name.human(count: count).downcase if exception.record
    default = I18n.t("pundit.defaults.#{act}", name: human_name) if human_name

    I18n.t "pundit.#{policy_name}.#{act}", default: default
  end

  def active_admin_message(exception)
    subject = exception.subject
    policy_name = "#{subject.to_s.underscore}_policy"
    act = "#{exception.action}?".try(:to_sym)
    act = :index? if act == :read? && action_name == "index"

    default = I18n.t(:default, scope: "pundit")

    if subject.try :model_name
      count = (act == :index?) ? 2 : 1
      human_name = subject.model_name.human(count: count).downcase

      default = I18n.t("pundit.defaults.#{act}", name: human_name)
    end

    I18n.t "pundit.#{policy_name}.#{act}", default: default
  end
end

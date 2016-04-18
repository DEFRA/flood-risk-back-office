require "rolify"

User.class_eval do
  devise :recoverable, :lockable, :invitable
  attr_accessor :assigned_role

  validates :disabled_comment, presence: { if: :disabled? }

  def self.policy_class
    Admin::UserPolicy
  end

  def disable(comment)
    update disabled_comment: comment,
           disabled_at: current_time_from_proper_timezone
  end

  def disable!(comment)
    update! disabled_comment: comment,
            disabled_at: current_time_from_proper_timezone
  end

  def enable!
    update! disabled_at: nil, disabled_comment: nil
  end

  def disabled?
    disabled_at.present?
  end

  def enabled?
    !disabled?
  end

  # Use ActiveJob to deliver Devise emails
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    if Rails.application.config.active_job.queue_adapter == :inline
      super
    else
      devise_mailer.send(notification, self, *args).deliver_later
    end
  end

  def active_for_authentication?
    super && enabled?
  end

  def inactive_message
    # If the user is diabled, and Devise "paranoid mode" is on,
    # display the message "Invalid email or password",
    # instead of the default "Your account is not activated yet" message
    (Devise.paranoid && disabled?) ? :invalid : super
  end
end

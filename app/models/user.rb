
class User < ActiveRecord::Base
  attr_accessor :assigned_role

  rolify role_cname: "Role",
         role_join_table_name: "users_roles",
         after_add: :add_to_role_names,
         after_remove: :remove_from_role_names

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable,
         :trackable,
         :validatable,
         :lockable,
         :invitable,
         :recoverable

  validate :password_meets_minimum_requirements
  validates :email, length: { maximum: 255 }

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

  def password_meets_minimum_requirements
    if password.present? && errors[:password].empty?
      # Password must have at least 1 uppercase, 1 lowercase and 1 number character
      unless password =~ /[A-Z]+/ && password =~ /[A-Z]+/ && password =~ /[0-9]+/
        errors.add :password, :invalid
      end
    end
  end

  def add_to_role_names(role)
    return unless role

    names = (role_names || []).split(", ")
    names.push role.name
    self.role_names = names.reject(&:blank?).uniq.sort.join(", ")
    save
  end

  def remove_from_role_names(role)
    return unless role

    names = (role_names || []).split(", ")
    names.delete role.name
    self.role_names = names.reject(&:blank?).uniq.sort.join(", ")
    self.role_names = nil if role_names.blank?

    save
  end
end

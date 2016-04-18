
class User < ActiveRecord::Base
  has_paper_trail class_name: "UserVersion"

  rolify role_cname: "Role",
         role_join_table_name: "users_roles",
         after_add: :add_to_role_names,
         after_remove: :remove_from_role_names

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :trackable, :validatable, :lockable, :invitable

  validate :password_meets_minimum_requirements
  validates :email, length: { maximum: 255 }

  private

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

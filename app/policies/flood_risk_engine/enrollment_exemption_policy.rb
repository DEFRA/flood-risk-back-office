module FloodRiskEngine
  # After https://docs.google.com/presentation/d/1SdugYDEOCqFT4rGLR06t0x3lu1WZIXxMh1YT7HYM6No/edit#slide=id.g1143cbcbed_0_1
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | States       | Pending | In progress | Withdrawn | Rejected | Approved | Deregistered | Expired |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Pending      | N/A     | Yes         | Yes       | Yes      | Yes      | No           | No      |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | In progress  | ?       | N/A         | Yes       | Yes      | Yes      | No           | No      |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Withdrawn    | No      | No          | N/A       | No       | No       | No           | No      |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Rejected     | No      | No          | No        | N/A      | No       | No           | No      |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Approved     | No      | No          | No        | No       | N/A      | Yes          | Yes     |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Deregistered | No      | No          | No        | No       | No       | N/A          | No      |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  #  | Expired      | No      | No          | No        | No       | No       | No           | N/A     |
  #  +--------------+---------+-------------+-----------+----------+----------+--------------+---------+
  # Converted to text with http://www.tablesgenerator.com/text_tables (via LibreOffice Calc)
  #
  # Statuses are: building, pending, being_processed, approved, rejected, expired, withdrawn
  class EnrollmentExemptionPolicy < ApplicationPolicy
    alias enrollment_exemption record
    delegate :enrollment, to: :record

    def show?
      user.present? && user.has_any_role?
    end

    def change_status?
      system_user?
    end

    def process?
      user_can_edit_and_status? :pending
    end
    alias in_progress? process?

    def withdraw?
      user_can_edit_and_status? :pending, :being_processed
    end
    alias reject? withdraw?
    alias approve? withdraw?

    def deregister?
      user_can_edit_and_status? :approved
    end
    alias expired? deregister?
    alias resend_approval_email? deregister?

    def assistance?
      user_can_edit? && enrollment.submitted?
    end

    def user_can_edit_and_status?(*statuses)
      return false unless enrollment.submitted?
      return false unless user_can_edit?
      enrollment_exemption.status_one_of?(*statuses)
    end

    def user_can_edit?
      system_user? || super_agent_user?
    end
  end
end

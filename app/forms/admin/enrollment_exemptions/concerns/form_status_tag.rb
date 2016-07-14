module Admin
  module EnrollmentExemptions
    module Concerns
      module FormStatusTag

        include Reform::Form::Module

        include StatusTag

        def status_tag
          super(enrollment_exemption.status, status_label)
        end

        def status_label
          return unless enrollment_exemption.status.present?
          I18n.t(enrollment_exemption.status, scope: "admin.status_label")
        end

        def enrollment_exemption
          raise "Instance method `#{__method__}` must be defined in #{self.class.name}"
        end

      end
    end
  end
end

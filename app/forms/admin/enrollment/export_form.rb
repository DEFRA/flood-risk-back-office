require "validates_timeliness/helper_methods"
require "reform/form/multi_parameter_attributes"
require "reform/form/active_model/form_builder_methods"

module Admin
  module Enrollment

    class ExportForm < BaseForm

      # See http://trailblazer.to/gems/reform/#multiparameter-dates
      feature Reform::Form::MultiParameterAttributes
      feature Reform::Form::ActiveModel::FormBuilderMethods

      extend ::ActiveModel::Validations::HelperMethods

      def initialize(model)
        super(model)
      end

      def params_key
        :admin_enrollment_export
      end

      property :from_date, multi_params:  true
      property :to_date, multi_params:  true
      property :state
      property :created_by

      # validates_timeliness does not seem to support message, just over ride via
      # en.activemodel.errors.models.admin.enrollment.export.attributes.to_date.on_or_after

      validates :from_date, presence: true
      validates_date :from_date, on_or_before: :today, allow_blank: true

      validates :to_date, presence: true
      validates_date :to_date, on_or_before: :today, allow_blank: true

      validates_date :to_date,
                     on_or_after: :from_date,
                     allow_blank: true

      validates :state, presence: { strict: true }
      validates :state, inclusion: { allow_blank: true, in: EnrollmentExport.states.keys }

      validates :created_by, presence: { strict: true }

      def save
        sync # need to populate model with the dates etc so we can gen good file name
        model.populate_file_name
        super
      end

    end
  end
end

require_dependency "reform"

module Admin
  class BaseForm < Reform::Form

    include ActionView::Helpers::TranslationHelper
    include ActiveModel::Validations
    include Reform::Form::ActiveModel

    # delegate :model_name, to: :model
    # delegate :to_model, to: :model

    def validate(params)
      super params.fetch(params_key, {})
    end

    def params_key
      raise "`params_key` must be defined in child classes"
    end

    protected

    def logger
      Rails.logger
    end
  end
end

require_dependency "reform"

module Admin
  class BaseForm < Reform::Form

    include ActionView::Helpers::TranslationHelper
    include ActiveModel::Validations
    include Reform::Form::ActiveModel

    # delegate :model_name, to: :model
    # delegate :to_model, to: :model

    def self.t(locale, args = {})
      I18n.t locale, args.merge(scope: locale_key)
    end

    def self.locale_key
      raise "Class method `#{__method__}` must be defined in #{name}"
    end

    def validate(params)
      super params.fetch(params_key, {})
    end

    def params_key
      raise "Instance method `#{__method__}` must be defined in #{self.class.name}"
    end

    protected

    def logger
      Rails.logger
    end
  end
end

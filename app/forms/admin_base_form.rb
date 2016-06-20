require_dependency "reform"

class AdminBaseForm < Reform::Form

  include ActionView::Helpers::TranslationHelper
  include ActiveModel::Validations
  include Reform::Form::ActiveModel

  # The following maybe required if reform versions bumped up from
  #     reform (2.1.0)  and reform-rails (0.1.0)
  # delegate :model_name, to: :model
  # delegate :to_key, to: :model
  # delegate :to_model, to: :model

  def validate(params)
    super params.fetch(params_key, {})
  end

  protected

  def logger
    Rails.logger
  end
end

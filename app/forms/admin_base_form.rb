require_dependency "reform"

class AdminBaseForm < Reform::Form

  include ActionView::Helpers::TranslationHelper
  include ActiveModel::Validations

  feature Reform::Form::ActiveModel::Validations

  def validate(params)
    super params.fetch(params_key, {})
  end

  protected

  def logger
    Rails.logger
  end
end

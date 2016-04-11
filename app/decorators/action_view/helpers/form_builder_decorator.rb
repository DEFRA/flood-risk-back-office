module BackOfficeCore
  module FormBuilderCapitalize
    private

    def submit_default_value
      super.try :capitalize
    end
  end
end

ActionView::Helpers::FormBuilder.send(:prepend, BackOfficeCore::FormBuilderCapitalize)

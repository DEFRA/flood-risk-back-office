Rails.application.routes.draw do
  devise_for :users, controllers: { :invitations => 'invitations' }

  mount FloodRiskEngine::Engine => "/fre"

  authenticated :user do
    root to: 'admin/enrollment_exemptions#index'
  end

  unauthenticated do
    devise_scope :user do
      root to: 'admin/sessions#new', as: "unauthenticated"
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update] do
      get :edit_disable
      patch :disable
      patch :enable
    end
    resources :enrollments, only: [:index, :show, :edit, :update, :new]
    resources :enrollment_exemptions, only: [:index, :show] do
      resources(
        :deregister,
        only: [:new, :create],
        path_names: {new: ""},
        controller: "enrollment_exemptions/deregister"
      )
      resources(
        :reject,
        only: [:new, :create],
        path_names: {new: ""},
        controller: "enrollment_exemptions/reject"
      )
      resources(
        :approve,
        only: [:new, :create],
        path_names: {new: ""},
        controller: "enrollment_exemptions/approve"
      )
      resources(
        :resend_approval_email,
        only: [:new, :create],
        path_names: {new: ""},
        controller: "enrollment_exemptions/resend_approval_email"
      )
      resources(
        :change_status,
        only: [:new, :create],
        path_names: {new: ""},
        controller: "enrollment_exemptions/change_status"
      )

      resource :assistance, only: [:edit, :update], controller: "enrollment_exemptions/assistance"

    end
    resources :enrollment_exports, only: [:index, :create, :show]
  end

  # We use high voltage to manage static content including error-pages
  #get "/pages/*id" => 'high_voltage/pages#show', as: :page, format: false

  # get "/dsc/enrollments/:state/:id", to: 'digital_services_core/enrollments#update'
  # get "/dsc/enrollments/:id", to: 'digital_services_core/enrollments#update'
  # match "(errors)/:status", to: 'digital_services_core/errors#show', via: :all, constraints: { status: /\d{3}/ }

  if Rails.env.development?
    mount GovukAdminTemplate::Engine, at: "/style-guide"

    # if ENV["ADD_STATE_JUMPER_TOOLBAR"] == "true"
    #   get "/enrollment_builder/:factory", to: 'enrollment_builder#build_dummy_data', as: :build_dummy_data
    #   get "/enrollment_builder/bulk/:number", to: 'enrollment_builder#bulk_load', as: :bulk_load
    # end
  end
end

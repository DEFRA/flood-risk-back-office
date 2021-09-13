Rails.application.routes.draw do
  devise_for :users, controllers: { :invitations => 'invitations' }

  authenticate :user do
    mount FloodRiskEngine::Engine => "/fre"
  end

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
      scope only: [:new, :create], path_names: { new: "" } do
        resources(
          :deregister,
          controller: "enrollment_exemptions/deregister"
        )
        resources(
          :reject,
          controller: "enrollment_exemptions/reject"
        )
        resources(
          :approve,
          controller: "enrollment_exemptions/approve"
        )
        resources(
          :resend_approval_email,
          controller: "enrollment_exemptions/resend_approval_email"
        )
        resources(
          :change_status,
          controller: "enrollment_exemptions/change_status"
        )
        resources(
          :withdraw,
          controller: "enrollment_exemptions/withdraw"
        )

        resources(
          :in_progress,
          controller: "enrollment_exemptions/in_progress"
        )
      end
      resource :assistance, only: [:edit, :update], controller: "enrollment_exemptions/assistance"
    end

    resources :enrollment_exports, only: [:index, :create, :show]
  end

  resources :enrollments, only: [:new, :create] do
    resources(
      :addresses,
      only: [:edit, :update],
      controller: "enrollments/addresses"
    )
    resources(
      :correspondence_contacts,
      only: [:edit, :update],
      controller: "enrollments/correspondence_contacts"
    )
    resources(
      :organisations,
      only: [:edit, :update],
      controller: "enrollments/organisations"
    )
    resources(
      :partner_addresses,
      only: [:edit, :update],
      controller: "enrollments/partner_addresses"
    )
  end

  mount DefraRubyEmail::Engine => "/email"
end

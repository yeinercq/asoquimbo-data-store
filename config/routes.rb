Rails.application.routes.draw do
  devise_for :users
  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "pages#home"

  resources :social_ecological_characterizations do
      collection do
        get "import_form"
        post "import_file"
      end
  end

  resources :monthly_reports do
    resources :activities, except: [ :index, :show ] do
      post :destroy_soure_file, on: :member
    end
  end

  resources :custom_select_lists, except: [ :show ] do
    resources :custom_option_lists, except: [ :show, :index ]
  end

  resources :collaborators, except: [ :show ]
end

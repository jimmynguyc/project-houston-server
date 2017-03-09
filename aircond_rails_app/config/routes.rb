Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'users#dashboard', as: :admin_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'sessions#new'
  end

  post '/firebase_update/:id' => 'airconds#update_website_from_firebase', as: :firebase_update
  resources :aircond_groups, only: [:create,:destroy,:index]

  resources :devices
  resources :airconds
  get 'aircond/:id/timer' => 'airconds#timer', as: :set_timer
  patch 'aircond/:id/timer' => 'airconds#timer_set', as: :timer_set
  post 'set_all_status/:status' => 'airconds#set_all_status', as: :set_all_status
  post 'limit_options' => 'airconds#limit_options', as: :limit_options
  patch 'aircond/:id/assign_group' => 'airconds#assign_group', as: :assign_group

  post '/app_state/:id' => 'airconds#app_set', as: :app_set
  
  get '/auth/nextacademy/callback' => 'sessions#create_from_omniauth'

  resources :phone_apps, only: [:index]
  post '/app_create' => 'phone_apps#create', as: :app_create
  patch '/approve_token/:id' => 'phone_apps#approve_token', as: :approve_token
  get '/get_token' => 'phone_apps#provide_token', as: :get_token
  get '/validate_token' => 'phone_apps#check_token', as: :validate_token
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

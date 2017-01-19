Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'users#dashboard', as: :admin_root
  end

  constraints Clearance::Constraints::SignedOut.new do
    root to: 'clearance/sessions#new'
  end
  patch 'user/:id/timezone_set' => 'users#timeset', as: :set_time_zone
  get 'aircond/:id/timer' => 'airconds#timer', as: :set_timer
  patch 'aircond/:id/timer' => 'airconds#timer_set', as: :timer_set
  post 'set_all_status/:status' => 'airconds#set_all_status', as: :set_all_status
  post 'update_all_status' => 'airconds#update_all_status', as: :update_all_status
  post 'limit_options' => 'airconds#limit_options', as: :limit_options
  get '/app_state' => 'airconds#app_get_all', as: :app_get
  post '/app_state/:id' => 'airconds#app_set', as: :app_set
  post '/app_create' => 'phone_apps#create', as: :app_create
  post '/firebase_update/:id' => 'airconds#firebase_update', as: :firebase_update


  resources :devices
  resources :airconds
  resources :phone_apps, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

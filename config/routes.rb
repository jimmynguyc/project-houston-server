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
  post 'set_all_state/:status' => 'airconds#set_all_state', as: :set_all_state
  post 'update_all_state' => 'airconds#update_all_state', as: :update_all_state
  post 'limit_options' => 'airconds#limit_options', as: :limit_options
  resources :devices
  resources :airconds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

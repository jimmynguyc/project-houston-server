Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new do
    root to: 'devices#index', as: :admin_root
  end
  
  constraints Clearance::Constraints::SignedOut.new do
    root to: 'clearance/sessions#new'
  end
  resources :devices
  resources :airconds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

module OmniAuth
  module Strategies
    # tells OmniAuth to load our strategy when the class is being used
    # defined in lib/omniauth/strategies/nextacademy.rb
    autoload :Nextacademy, Rails.root.join('lib', 'omniauth', 'strategies', 'nextacademy')
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :nextacademy, ENV['nextacademy_auth_id'], ENV['nextacademy_auth_secret']
end

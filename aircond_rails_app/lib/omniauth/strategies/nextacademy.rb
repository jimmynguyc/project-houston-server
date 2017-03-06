require 'omniauth'

module OmniAuth
  module Strategies
    class Nextacademy < OmniAuth::Strategies::OAuth2
      include OmniAuth::Strategy

      # provider name
      option :name, :nextacademy
      option :client_options, {
        site: "https://admission.nextacademy.com",
        authorize_url: "/oauth/authorize"
      }

      # request.env['omniauth.auth']['info']
      info do
        {
          email: raw_info["email"],
          name: raw_info["first_name"]
        }
      end

      # request.env['omniauth.auth']['uid']
      uid { raw_info['user_uuid'] }

      # request.env['omniauth.auth']['extra']
      # extra {}

      def initialize(app, id, secret, options)
        # sets the client id and secret
        self.class.option :client_id, id
        self.class.option :client_secret, secret
        super(app, options)
      end

      # gets a json containing all user fields from provider
      def raw_info
        @raw_info ||= access_token.get('/api/v1/me').parsed
      end

      # needed to solve invalid redirect_uri error
      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

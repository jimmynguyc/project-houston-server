class SessionsController < Clearance::SessionsController

  def create_from_omniauth
    auth_hash = request.env["omniauth.auth"]
    p auth_hash
    p auth_hash["info"]["oauth_admin"]
    p auth_hash["oauth_admin"]
    p "="*30
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
    User.oauth_sign_up?(true)
    if authentication.user
      user = authentication.user 
      authentication.update_token(auth_hash)
    else
      user = User.create_with_auth_and_hash(authentication, auth_hash)
    end
    sign_in(user) if !user.nil?
    User.oauth_sign_up?(false)
    redirect_to root_url
  end
end


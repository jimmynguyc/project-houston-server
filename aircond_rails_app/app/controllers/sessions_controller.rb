class SessionsController < Clearance::SessionsController
  def create
    auth_hash = request.env['omniauth.auth'] 
    p auth_hash
  end
end
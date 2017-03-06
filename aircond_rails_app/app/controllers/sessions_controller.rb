class SessionsController < Clearance::SessionsController
  def create
    auth_hash = request.env['omniauth.auth'] 
    byebug
  end
end
class User < ApplicationRecord
  include Clearance::User
 	  enum role:{
	    'admin' =>0,
	    'common' =>1
	  }

  def self.create_with_auth_and_hash(authentication, auth_hash)
      user = User.create!(email: auth_hash["info"]["email"])
      user.authentications << (authentication)      
      return user
  end

  def password_optional?
      p request.env["omniauth.auth"]
      true
  end
end


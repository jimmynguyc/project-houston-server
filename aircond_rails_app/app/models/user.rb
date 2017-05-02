class User < ApplicationRecord
  include Clearance::User
 	  enum role:{
	    'admin' =>0,
	    'common' =>1
	  }
  has_many :authentications, :dependent => :destroy

  @@oauth = false

  def self.create_with_auth_and_hash(authentication, auth_hash)
      if auth_hash["info"]["oauth_admin"]==true
        user = User.create!(email: auth_hash["info"]["email"])
        user.authentications << (authentication)      
        return user
      else
        return nil
      end
  end

  def self.oauth_sign_up?(bool)
    @@oauth = bool
  end

  def password_optional?
      true if @@oauth == true
  end
end


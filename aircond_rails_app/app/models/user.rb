class User < ApplicationRecord
  include Clearance::User
 	  enum role:{
	    'admin' =>0,
	    'common' =>1
	  }
  has_many :authentications, :dependent => :destroy

  @@facebook = false

  def self.create_with_auth_and_hash(authentication, auth_hash)
      user = User.create!(email: auth_hash["info"]["email"])
      user.authentications << (authentication)      
      return user
  end

  def self.facebook_sign_up?(bool)
    @@facebook = bool
  end

  def password_optional?
      true if @@facebook == true
  end
end


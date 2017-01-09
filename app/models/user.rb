class User < ApplicationRecord
  include Clearance::User
 	  enum role:{
	    'admin' =>0,
	    'common' =>1
	  }
end

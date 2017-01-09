class PhoneApp < ApplicationRecord
	belongs_to :user
	  enum status:{
	    'PENDING' =>0,
	    'ACCEPTED' =>1,
	    'REJECTED' =>2
	  }
end

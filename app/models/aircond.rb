class Aircond < ApplicationRecord
	belongs_to :device
	  enum status:{
	    'OFF' =>0,
	    'ON' =>1,
	    'PENDING' =>2
	  }
end

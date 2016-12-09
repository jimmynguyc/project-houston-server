class Aircond < ApplicationRecord
	belongs_to :device
	belongs_to :aircond_state
	  enum status:{
	    'OFF' =>0,
	    'ON' =>1,
	    'PENDING' =>2
	  }
end

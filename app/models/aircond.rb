class Aircond < ApplicationRecord
	belongs_to :device
	belongs_to :aircond_state,  optional: true
	  enum status:{
	    'OFF' =>0,
	    'ON' =>1,
	    'PENDING' =>2
	  }
	  enum mode:{
	    'DRY' =>0,
	    'HEALTHY' =>1
	  }
	  enum fan_speed:{
	    'AUTO' =>0,
	    'LOW' =>1,
	    'MEDIUM' =>2,
	    'HIGH' =>3
	  }
	def send_signal(status:,mode:,temperature:,fan_speed:)
		self.device.url
		true
		#send http request with access token to raspberry pi to get current state
		#evaluate remote state and compare with current state
		#send http request to modify state if different
		#else 
	end
end

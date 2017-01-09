require 'unirest'

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
	    'WET' =>1,
	    'COLD' => 2
	  }
	  enum fan_speed:{
	    'AUTO' =>0,
	    'LOW' =>1,
	    'MEDIUM' =>2,
	    'HIGH' =>3
	  }
	def get_state
		raspi = self.device
		path = 'http://' + raspi.url + "/state.py"
		response = Unirest.get(path,parameters:{access_token:raspi.access_token}) 
		#assumes that receive a hash {status:"ON"}
		return {status:response.body.strip}	
	end

	def send_signal(command)
		raspi = self.device
		path = 'http://'+ raspi.url + "/state.py"
    params = {access_token:raspi.access_token, command:command}
		response = Unirest.post(path,parameters:params)

	end

end


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
	    'HEALTHY' =>1
	  }
	  enum fan_speed:{
	    'AUTO' =>0,
	    'LOW' =>1,
	    'MEDIUM' =>2,
	    'HIGH' =>3
	  }
	def get_state
		#obtain state of aircond
		raspi = self.device
		path = raspi.url + "/get_state"
		response = Unirest.get(path,parameters:{access_token:raspi.access_token}) 
		#tentative set that if on (assume returned result is a string "ON"), return ON
		#response.body.status == "ON"
		return response
	end

	def send_signal(status:,mode:,temperature:,fan_speed:)
		raspi = self.device
		path = raspi.url + "/change_state"
		#possible ways to change state
		#1. store IR signals in database that correspond to each attribute value and use them to compile a conf file
		#2. store IR signals directly as the value of attribute in the databaser
		#ALT
		#v3 : obtain corresponding state directly from state database
		state = {status:status} #future versions can extend more arguments
		params = {state:state,access_token:raspi.access_token}  #should send IR signal over OR send the entire test for the conf file
		response = Unirest.post(path,parameters:params)
	end

	def decipher_signal
	end
end

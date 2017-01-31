require 'unirest'

class Aircond < ApplicationRecord
	belongs_to :device
	belongs_to :aircond_state,  optional: true

	before_update :check_state
	after_save :update_firebase

	include ApplicationHelper
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
		path = raspi.url + "/state.py"
		response = Unirest.get(path,parameters:{access_token:raspi.access_token}) 
		#assumes that receive a hash {status:"ON"}
		return {status:response.body.strip}	
	end

	def send_signal(command)
		raspi = self.device
		path = raspi.url + "/state.py"
    params = {access_token:raspi.access_token, command:command}
		response = Unirest.post(path,parameters:params)
		check_power_status if self.changes.keys.include?(:status)
	end

	def update_firebase
		firebase = Firebase::Client.new("https://project-houston.firebaseio.com")
		data = self.slice(:status,:temperature,:mode,:fan_speed)
		firebase.update('/airconds/'+self.id.to_s, data)		
	end

	def check_state
		send_signal(get_command) if !(self.changes.keys & [:status,:temperature,:mode,:fan_speed]).empty?
		byebug
		check_power_status	
	end

	def check_power_status
		# get_state == self.changed_attributes[:status]
		false
	end

	def get_command
		data = self.slice(:status,:temperature, :mode, :fan_speed)
		data.keys.each do |key|
			data[key] = self.changed_attributes[key]
		end
		data = data.slice(:temperature,:mode, :fan_speed) if !self.changes.keys.include? :status 
		decipher_command(data)
	end
end


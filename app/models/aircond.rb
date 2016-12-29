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
		path = 'http://' + raspi.url + "/state.py"
		response = Unirest.get(path,parameters:{access_token:raspi.access_token}) 
		#assumes that receive a hash {status:"ON"}
		return response	
	end

	def send_signal(status:) #,mode:,temperature:,fan_speed:
		raspi = self.device
		path = 'http://'+ raspi.url + "/state.py"

		state = validate_AC_controls(status:status)  #future versions can extend more arguments v1
		if state
			create_lircd_conf_file(state[:signal] )
			# params = {access_token:raspi.access_token, file: File.new('lircd.conf')}  #sends the entire text for the conf file
      params = {access_token:raspi.access_token, status:'OFF'}

			response = Unirest.post(path,parameters:params)
		else
			return "Invalid command signal"
		end
	end

	private

	def validate_AC_controls(status:)
		if InfraredSignal.pluck(:command).include? status
			state = {signal:InfraredSignal.find_by_command(status).ir_signal_in_conf}
		else
			state = nil
		end
		return state
	end

	def create_lircd_conf_file(signal)
			lircd_conf = 'begin remote\n\n   name  Daikin\n   flags RAW_CODES\n   eps            30\n   aeps          100\n\n   frequency    38000\n\n       begin raw_codes\n           ' + signal + '\n       end raw_codes\n\nend remote'
			%x'rm -rf lircd.conf'
			%x'echo "#{lircd_conf}">> lircd.conf'		

	end
end


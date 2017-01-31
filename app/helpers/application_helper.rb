module ApplicationHelper
	def all_timezones
		@timezones = []
		ActiveSupport::TimeZone.all.each{|zone| @timezones << zone.name}
		return @timezones.sort
	end

	def generate_security_token
		@token = SecureRandom.hex
	end

	def is_admin?
		current_user.role == 'admin'
	end

	def decipher_command(parameters)
		#create the command for the raspi to send
		status,mode,temperature,fan_speed = '','','',''

		parameters.each do |key,value|
			if value == nil
			elsif key == 'mode' && value != ''
				mode = value.to_s
			elsif key == 'fan_speed'  && value != ''
				value = 'A' if value == 'AUTO'
				value = Aircond.fan_speeds.keys.index(value) if Aircond.fan_speeds.keys.include?(value)
				fan_speed = "F"+value.to_s
			elsif key == 'temperature' && value != ''
				temperature = "T"+value.to_s
			elsif key == 'status' && value != ''
				status = value.to_s + ' '
			end
		end

		status + mode+fan_speed+temperature
	end
end

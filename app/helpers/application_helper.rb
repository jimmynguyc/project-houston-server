module ApplicationHelper
	def all_timezones
		@timezones = []
		ActiveSupport::TimeZone.all.each{|zone| @timezones << zone.name}
		return @timezones.sort
	end

	def generate_security_token
		@token = SecureRandom.hex
	end
end

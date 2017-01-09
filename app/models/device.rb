require 'unirest'

class Device < ApplicationRecord
	def set_token
		response = Unirest.post(self.url,parameters:{access_token:self.access_token})
	end
end

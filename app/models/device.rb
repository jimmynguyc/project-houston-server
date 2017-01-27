require 'unirest'

class Device < ApplicationRecord
  validates :url, format:{ with: /http:\/\/.*/, message:'must start with http://'}
	def set_token
		response = Unirest.post(self.url,parameters:{access_token:self.access_token})
	end
end

require 'unirest'

class Device < ApplicationRecord
  validates :url, format:{ with: /http:\/\/.*/, message:'must start with https://'}
  before_create :generate_access_token

  def generate_access_token
    self.access_token= SecureRandom.hex
    set_token
  end

  def set_token
    response = Unirest.post(self.url + '/give_token.py',parameters:{access_token:self.access_token})
  end


end

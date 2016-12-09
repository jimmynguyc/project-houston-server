class Device < ApplicationRecord
	has_one :aircond
	validates :device_type, presence: true
  enum device_type:{
    'Air Conditioner': 0
  }

end

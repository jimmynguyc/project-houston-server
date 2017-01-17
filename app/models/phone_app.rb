class PhoneApp < ApplicationRecord
  scope :filter_by_status, -> (status){where(status:status)}

	belongs_to :user
	  enum status:{
	    'PENDING' =>0,
	    'ACCEPTED' =>1,
	    'REJECTED' =>2
	  }
end

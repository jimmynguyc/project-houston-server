class PhoneApp < ApplicationRecord
  scope :filter_by_status, -> (status){where(status:status)}
  validates :user_name, uniqueness:true
	  enum status:{
	    'PENDING' =>0,
	    'ACCEPTED' =>1,
	    'REJECTED' =>2
	  }
end

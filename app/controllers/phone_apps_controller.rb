class PhoneAppsController < ApplicationController
	skip_before_filter  :verify_authenticity_token
	include ApplicationHelper
	def create
		phoneapp=PhoneApp.new(phone_app_params)
		if phoneapp.save
			render json:{response:'PhoneApp record created, awaiting approval'}
		else
			render json:{response:'PhoneApp record not created, check you code.'}
		end
	end

	def index
	end

	def app_approve_token
		@phone_app = PhoneApp.find(params[:id])
		if is_admin
			@phone_app.status = params[:status]
			@phone_app.access_token = generate_security_token if @phone_app.status == "ACCEPTED"
			@phone_app.access_token.save
			#how to send to specifc app
			redirect_to :index
		else
			flash[:warning] = "You do not have authority to execute this action"
			redirect_to root_path
		end
	end

	private
	def phone_app_params
		params.require(:phone_app).permit('user_name')
	end
end

# {user_name: "test"}

# Create Phone App  >> Firebase
#  {user_name, password, acess_token}

#  
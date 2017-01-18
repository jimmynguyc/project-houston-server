class PhoneAppsController < ApplicationController
	skip_before_filter  :verify_authenticity_token
	include ApplicationHelper

	def create
		phone_app=PhoneApp.new(phone_app_params)
		if phone_app.save
			render json:{response:'PhoneApp record created, awaiting approval'}
		else
			render json:{response:'PhoneApp record not created, check you code.'}
		end
	end

	def index
	end

	def app_approve_token
		if is_admin
			@phone_app = PhoneApp.find_or_initialize_by(user_name:params[:email])
			@phone_app.status = params[:status]
			@phone_app.access_token = generate_security_token if @phone_app.status == "ACCEPTED"
			@phone_app.access_token.save
			#how to send to specifc app
			render json:{app_token:@phone_app.access_token}
		else
			render json:{response:'Failed to approve. You are not an admin'}
		end
	end

	private
	def phone_app_params
		params.require(:phone_app).permit('user_name')
	end
end


# 	def app_approve_token
# 		@phone_app = PhoneApp.find(params[:id])
# 		if is_admin
# 			@phone_app.status = params[:status]
# 			@phone_app.access_token = generate_security_token if @phone_app.status == "ACCEPTED"
# 			@phone_app.access_token.save
# 			#how to send to specifc app
# 			redirect_to :index
# 		else
# 			flash[:warning] = "You do not have authority to execute this action"
# 			redirect_to root_path
# 		end
# 	end

# 	private
# 	def phone_app_params
# 		params.require(:phone_app).permit('user_name')
# 	end
# end

class PhoneAppsController < ApplicationController
	scope :filter_by_status, -> (status){where(status:status)}
	include ApplicationHelper
	def create
		PhoneApp.create(phone_app_params)
		render json:{response:'PhoneApp record created, awaiting approval'}
	end

	def index
		@phone_apps = PhoneApp.filter_by_status(params[:status])
		@phone_apps = PhoneApp.all if params[:status] == nil
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

class PhoneAppsController < ApplicationController
	skip_before_filter  :verify_authenticity_token
	include ApplicationHelper

	def create
		phone_app=PhoneApp.new(phone_app_params)
		if phone_app.save
			render json:{response:'PhoneApp record created, awaiting approval'}
		else
			render json:{response:'PhoneApp record not created, check your code.'}
		end
	end

	def index
		if is_admin?
			if params[:filter] == nil || params[:filter] == "ALL"
				@phone_apps = PhoneApp.all.order(:id)
			else
				@phone_apps = PhoneApp.filter_by_status(params[:filter]).order(:id)
			end
			respond_to do |format|
				format.html {render 'index.html.erb'}
				format.js {render 'index.js.erb'}
			end
		else
			flash[:warning] = "You are not authorized."
			rediect_to root_path
		end
	end

	def approve_token
		@phone_app = PhoneApp.find(params[:id])
		if is_admin?
			@phone_app.update(status:params[:phone_app][:status])
			flash[:notice] = "Mobile app approved"
			redirect_to phone_apps_path
		else
			flash[:warning] = "You do not have authority to execute this action"
			redirect_to root_path
		end
	end

	def provide_token
		phone_app = PhoneApp.find_by(user_name:params[:user_name])
		phone_app = phone_app.authenticate(params[:password]) if !phone_app.nil?
		if phone_app
			if phone_app.status == 'ACCEPTED'
				phone_app.update(access_token:generate_security_token)
				render json:{app_token:phone_app.access_token}
			elsif phone_app.status == 'REJECTED'
				render json:{response:'Your app ha been rejected'}
			else
				render json:{response:'Your app has not been approved'}
			end
		else
			render json:{response: 'Invalid user_name or password'}
		end
	end

	def check_token
		phone_app = PhoneApp.find_by(user_name:params[:user_name])
		if phone_app
			if phone_app.access_token == params[:app_token]
				render json:{response:'Your current token is valid'}
			else	
				render json:{response:'Your current token is invalid'}
			end
		else
			render json:{response: 'Invalid user_name or password'}
		end
	end

	private
	def phone_app_params
		params.require(:phone_app).permit('user_name','password')
	end

end



	# def app_approve_token
	# 	if is_admin
	# 		@phone_app = PhoneApp.find_or_initialize_by(user_name:params[:email])
	# 		@phone_app.status = params[:status]
	# 		@phone_app.access_token = generate_security_token if @phone_app.status == "ACCEPTED"
	# 		@phone_app.access_token.save
	# 		#how to send to specifc app
	# 		render json:{app_token:@phone_app.access_token}
	# 	else
	# 		render json:{response:'Failed to approve. You are not an admin'}
	# 	end
	# end
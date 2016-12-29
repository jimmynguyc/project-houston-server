class AircondsController < ApplicationController 
	before_action :set_aircond, only: [:edit,:update,:timer,:timer_set]
	def new
		@aircond = Aircond.new
	end

	def create
		device= Device.new(device_params)
		if device.save
			ac = Aircond.create(device_id:device.id)
			redirect_to root_path
		else 
			render :new
		end
	end

	def edit
	end

	def update
		#v1 change ON/OFF 

		aircond_params[:status] 
		response = @aircond.get_state
		
		if response.body == "0\n" && aircond_params[:status] == 'OFF'
			flash[:warning] = "Aircond is already #{aircond_params[:status]}"
			redirect_to root_path
		# elsif response.code != 200
		# 	flash[:warning] = 'Current state was not obtained! Please try again.'
		# 	render :edit
	  elsif response.body == "1\n" && aircond_params[:status] == 'ON'
			flash[:warning] = "Aircond is already #{aircond_params[:status]}"
			redirect_to root_path
		else
			if @aircond.send_signal(aircond_params.to_h.symbolize_keys.select { |k,v| k == :status }) == "Invalid command signal"
				flash[:warning] = "Invalid command signal"
				render :edit
			end

			response = @aircond.get_state
			if response.body["status"] == aircond_params[:status]
				#update aircond_attr
				@aircond.update(aircond_params) 
				flash[:notice] = 'Aircond state was successfuly changed'
				redirect_to root_path
			else
			flash[:warning] = 'Signal could not be send! Please try again.'
			render :edit
			end
		end 
	end

	def timer
		Time.zone = current_user.timezone
		@current_timer = Time.zone.parse(@aircond.timer.to_s)
		render 'airconds/timer_form'
	end

	def timer_set
		Time.zone = current_user.timezone
		trigger_time = Time.zone.parse(params.permit![:aircond][:timer])
		@aircond.update(timer:Time.zone.local_to_utc(trigger_time))
		redirect_to root_path
	end

	private
	def device_params
		params.require(:aircond).require(:device).permit(:url,:access_token)
	end

	def aircond_params
		params.require(:aircond).permit(:status,:mode,:temperature,:fan_speed)
	end

	def set_aircond
		@aircond = Aircond.find(params[:id])
	end
end

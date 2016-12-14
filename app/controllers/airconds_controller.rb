class AircondsController < ApplicationController
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
		@aircond = Aircond.find(params[:id])
	end

	def update
		@aircond = Aircond.find(params[:id])
		#v1 change ON/OFF state
		response = @aircond.get_state
		if response.body[:status] == aircond_params[:status]
			flash[:warning] = 'Aircond is already #{aircond_params[:status]}'
		elsif response.code != 200
			flash[:warning] = 'Current state was not obtained! Please try again.'
			render :edit
		else
			@aircond.send_signal(aircond_params.to_h.symbolize_keys)
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

	private
	def device_params
		params.require(:aircond).require(:device).permit(:url,:access_token)
	end

	def aircond_params
		params.require(:aircond).permit(:status,:mode,:temperature,:fan_speed)
	end
end

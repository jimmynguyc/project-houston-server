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
		byebug
		if @aircond.send_signal(aircond_params.to_h.symbolize_keys)
			#update aircond_attr
			@aircond.update(aircond_params)
			redirect_to root_path
		else
			flash[:warning] = 'Signal was not sent correctly!'
			render :edit
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

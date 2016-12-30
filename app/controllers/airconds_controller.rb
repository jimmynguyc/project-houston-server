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
		if aircond_params[:alias]
			@aircond.update(alias:aircond_params[:alias])
			render :edit
		end

		signal_status = 'pending'
		byebug
		if same_status?
			@aircond.update(status:aircond_params[:status]) if @aircond.status != aircond_params[:status]
			flash[:warning] = "Aircond is already #{aircond_params[:status]}"
			redirect_to root_path
		else
			if @aircond.send_signal(status:aircond_params[:status]) == "Invalid command signal"
				flash[:warning] = "Invalid command signal"
				render :edit
			else
				if same_status?
					@aircond.update(aircond_params) 
					flash[:notice] = 'Aircond state was successfuly changed'
					redirect_to root_path
				else
					flash[:warning] = "Aircond state was not change. Remains as #{ac_state[:status]}"
					render :edit
				end
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
		job = Sidekiq::Cron::Job.new(name:"AcTimer worker - #{@aircond.alias}", cron: " #{trigger_time.min} #{trigger_time.hour} * * 1-5 #{Time.zone.name}", class:'AcTimerWorker', args:{aircond_id:@aircond.id,status:'ON'})
		if job.valid?
			job.save
			@aircond.update(timer:Time.zone.local_to_utc(trigger_time))
			redirect_to root_path
		else
			flash[:warning] = 'Invalid Job'
			puts job.errors
			redirect_to set_timer_path
		end
	end

	def set_all_state
		@airconds= Aircond.all
		@airconds.each do |ac|
			ac.send_signal(status:params[:status])
			ac.update(status:ac.get_state[:status])
		end	
		flash[:warning] = "Airconds with aliases  #{Aircond.where('status != ?', Aircond.statuses[params[:status]]).pluck(:alias)} were not successfully #{params[:status]}"
		redirect_to root_path
	end

	def update_all_state
		@airconds= Aircond.all
		@airconds.each do |ac|
			ac_state=ac.get_state
			ac.update(status:ac_state[:status]) if ac_state[:status]
		end
		redirect_to root_path
	end

	private
	def device_params
		params.require(:aircond).require(:device).permit(:url,:access_token)
	end

	def aircond_params
		params.require(:aircond).permit(:status,:mode,:temperature,:fan_speed,:alias)
	end

	def set_aircond
		@aircond = Aircond.find(params[:id])
	end

	def same_status?
		ac_state= @aircond.get_state
		ac_state[:status]==aircond_params[:status]	
	end
end

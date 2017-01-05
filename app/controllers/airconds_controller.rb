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
		generate_selection(@aircond.mode)
	end

	def update
		#path to edit the alias of aircond for easier understanding of location
		if aircond_params[:alias]
			@aircond.update(alias:aircond_params[:alias])
			flash[:notice] = "Alias Updated"
			render :edit
		end

		#path to changing status and state of aircond.
		cmd = decipher_command
		if same_status?
			@aircond.update(status:aircond_params[:status]) if @aircond.status != aircond_params[:status]
			@aircond.send_signal(cmd) if validate_AC_controls(cmd)
			flash[:warning] = "Aircond is already #{aircond_params[:status]}"
			redirect_to root_path
		elsif aircond_params[:status]
			if validate_AC_controls(cmd) && validate_AC_controls(aircond_params[:status])
				@aircond.send_signal(aircond_params[:status] + ' ' + cmd)
					if same_status?
						@aircond.update(aircond_params) 
						flash[:notice] = 'Aircond state was successfuly changed'
						redirect_to root_path
					else
						flash[:warning] = "Aircond state was not change. Remains as #{@aircond.get_state[:status]}"
						render :edit
					end
			else
				flash[:warning] = "Invalid command signal"
				render :edit
			end
		end 
	end

	def timer
		#renders the form for setting aircond timer
		Time.zone = current_user.timezone
		@current_timer = Time.zone.parse(@aircond.timer.to_s)
		render 'airconds/timer_form'
	end

	def timer_set
		#sets the job for timer to execute
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

	def set_all_status
		#sets all the aircond statuses..
		@airconds= Aircond.all
		@airconds.each do |ac|
			ac.send_signal(params[:status]) if ac.get_state[:status] != params[:status] 
			ac.update(status:ac.get_state[:status])
		end	
		flash[:warning] = "Airconds with aliases  #{Aircond.where('status != ?', Aircond.statuses[params[:status]]).pluck(:alias)} were not successfully #{params[:status]}"
		redirect_to root_path
	end

	def update_all_status
		#updates the server database with the current status of all airconds
		@airconds= Aircond.all
		@airconds.each do |ac|
			ac_state=ac.get_state
			ac.update(status:ac_state[:status]) if ac_state[:status]
		end
		redirect_to root_path
	end

	def limit_options
		#ajax path to responsively limit the options on edit page on selection of aircond mode
		generate_selection(params[:mode])
		render json:{fan_speed:@fan_speed_selection, temperature:@temperature_selection}
	end

	def app_get_all
		if validate_app_token(params[:app_token])
			all_airconds = {}
			Aircond.all.each do |ac|
				# ac_state=ac.get_state
				# ac.update(status:ac_state[:status]) if ac_state[:status]
				all_airconds[ac.id]= ac.slice(:status,:mode,:fan_speed,:temperature,:alias)
			end
			output= {airconds:all_airconds}
			render json:output
		else
			render json:{response:"Invalid Token"}
		end
	end

	def app_set
		if validate_app_token(params[:app_token])
		else
			render json:{response:"Invalid Token"}
		end
	end

	private

	def device_params
		params.require(:aircond).require(:device).permit(:url,:access_token)
	end

	def aircond_params
		params.require(:aircond).permit(:status,:mode,:fan_speed,:temperature,:alias)
	end

	def set_aircond
		@aircond = Aircond.find(params[:id])
	end

	def same_status?
		ac_state= @aircond.get_state
		ac_state[:status]==aircond_params[:status]	
	end

	def decipher_command
		#create the command for the raspi to send
		mode,temperature,fan_speed = '','',''
		aircond_params.each do |key,value|
			if key == 'mode'
				mode = value.to_s
			elsif key == 'fan_speed'
				value = 'A' if value = 'AUTO'
				value = Aircond.fan_speeds.keys.index(value) if Aircond.fan_speeds.keys.include?(value)
				fan_speed = "F"+value.to_s
			elsif key == 'temperature'
				temperature = "T"+value.to_s
			end
		end
		mode+fan_speed+temperature
	end

	def generate_selection(mode)
		#generate the options available for views
		@fan_speed_selection = Aircond.fan_speeds.keys
		@temperature_selection = (16..30).to_a
		if mode == 'DRY'
			@fan_speed_selection = @fan_speed_selection - ["AUTO"]
			@temperature_selection = []
		elsif mode == 'WET'
			@fan_speed_selection = []
		end
	end

	def validate_AC_controls(command)
		#ENSURE no invalid commands sent
		state = nil
		state = {signal:InfraredSignal.find_by_command(command).ir_signal_in_conf} if InfraredSignal.pluck(:command).include? command	
		return state
	end

	def validate_app_token(token)
		app_token = '12345678' #temp
		app_token == token
	end
end

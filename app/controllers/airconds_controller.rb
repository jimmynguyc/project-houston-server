
class AircondsController < ApplicationController 
	before_action :set_aircond, only: [:edit,:update,:timer,:timer_set,:app_set,:update_website_from_firebase]
	before_action :validate_app_token, only: [:app_set]

	skip_before_filter  :verify_authenticity_token, only: [:app_get_all,:app_set]
	include ApplicationHelper

	def new
		@aircond = Aircond.new
	end

	def create
		device= Device.new(device_params)
		if device.save
			ac = Aircond.create(device_id:device.id)
			redirect_to root_path
		else 
			@aircond = Aircond.new
			flash[:warning] = "#{device.errors.full_messages[0]}"
			render :new
		end
	end

	def edit
		generate_selection(@aircond.mode)
	end

	def update
			@aircond.update(alias:aircond_params[:alias])
			byebug
			cmd = decipher_command(aircond_params)

			if validate_AC_controls(cmd)
				if @aircond.update(aircond_params) 
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
		job = Sidekiq::Cron::Job.new(name:"AcTimer worker - #{@aircond.alias}", cron: " #{trigger_time.min} #{trigger_time.hour} * * 1-5 #{Time.zone.name}", class:'AcTimerWorker', args:{aircond_id:@aircond.id,status:params[:aircond][:status]})
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

	def limit_options
		#ajax path to responsively limit the options on edit page on selection of aircond mode
		generate_selection(params[:mode])
		render json:{fan_speed:@fan_speed_selection, temperature:@temperature_selection}
	end

	def app_set	
		if validate_app_token(params[:user_name],params[:app_token])
			cmd = decipher_command(aircond_params)
			#refactor for readability/ similar to update method
			if same_status?
				@aircond.update(status:aircond_params[:status]) if @aircond.status != aircond_params[:status]
				@aircond.send_signal(cmd) if validate_AC_controls(cmd)
				@aircond.update(aircond_params) 
				render json:{response: "Aircond is already #{aircond_params[:status]}"}
			elsif aircond_params[:status]
				ac_status_validity = validate_AC_controls(aircond_params[:status])
				ac_settings_validity = validate_AC_controls(cmd)
				if ac_status_validity || ac_settings_validity
					ac_status_command = aircond_params[:status] if ac_status_validity
					ac_settings_command = cmd if ac_settings_validity
					final_command = ac_status_command || ac_settings_command
 					final_command = ac_status_command + ' ' + ac_settings_command if ac_status_validity && ac_settings_validity
					@aircond.send_signal(final_command)
						if same_status?
							@aircond.update(aircond_params) 

							render json:{response:'Aircond state was successfuly changed'}
						else
							render json:{response:"Aircond state was not change. Remains as #{@aircond.get_state[:status]}"}
						end
				else
					render json:{response:"Invalid command signal"}
				end
			end 	

		else
			render json:{response:"Invalid Token"}
		end
	end

	def update_website_from_firebase
		arguments = aircond_params
		sanitize_params(arguments)
		@aircond.update(arguments) 
		render json:{response:'Updated'}
	end

	private

	def device_params
		params.require(:aircond).require(:device).permit(:url)
	end

	def aircond_params
		params.require(:aircond).permit(:status,:mode,:fan_speed,:temperature,:alias)
	end

	def set_aircond
		@aircond = Aircond.find(params[:id])
	end

	def sanitize_params(arguments)
		arguments[:temperature] = arguments[:temperature].to_i
		arguments[:fan_speed] = Aircond.fan_speeds[arguments[:fan_speed]]		
	end

	def same_status?
		ac_state= @aircond.get_state
		ac_state[:status]==aircond_params[:status]	
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

	def validate_AC_controls(commands)
		#ENSURE no invalid commands sent
		previous_cmd = true
		cmd_validity = true
		commands.split(' ').each do |command| 
			current_cmd = InfraredSignal.pluck(:command).include? command	
			cmd_validity = previous_cmd && current_cmd
			previous_cmd = cmd_validity
		end
		return cmd_validity
	end

	def validate_app_token(user_name,token)
		app_token = PhoneApp.find_by(user_name:user_name)
		app_token.access_token  == token if !app_token.nil?
	end
end
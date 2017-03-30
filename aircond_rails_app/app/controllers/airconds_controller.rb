
class AircondsController < ApplicationController 
	before_action :set_aircond, only: [:edit,:update,:timer,:timer_set,:app_set,:update_website_from_firebase,:assign_group]
	before_action only: [:app_set] {validate_app_token(params[:user_name],params[:app_token])}
	skip_before_filter  :verify_authenticity_token, only: [:app_get_all,:app_set]
	before_action :set_paper_trail_whodunnit, only: [:create,:update,:set_all_status]
	def new
		@aircond = Aircond.new
		@current_time= Time.zone.now
	end

	def create
		device= Device.new(device_params)	
		if device.save
			ac = Aircond.new(device_id:device.id,alias:aircond_params[:alias])
			ac.save
			ac.set_id
			ac.update(status:'OFF',mode:'COLD',fan_speed:'AUTO',temperature:20)
			redirect_to root_path
		else 
			@aircond = Aircond.new
			flash[:warning] = "#{device.errors.full_messages[0]}"
			render :new
		end
	end

	def edit

		generate_selection(@aircond.mode)
		@current_timer = Time.zone.parse(@aircond.timer.to_s)
		@current_time= Time.zone.now
		respond_to do |format|
			format.html {}
			format.js {
				generate_selection(params[:mode])
				render json:{fan_speed:@fan_speed_selection,temperature:@temperature_selection}
			}
		end
	end

	def update
			@current_timer = Time.zone.parse(@aircond.timer.to_s)
			@current_time= Time.zone.now
			@aircond.update(alias:aircond_params[:alias]) if aircond_params.keys.include? "alias"
			cmd = decipher_command(aircond_params)
			generate_selection(@aircond.mode)
			@path = :edit

			if validate_AC_controls(cmd)
				if @aircond.check_device_status
					if @aircond.update(aircond_params) 
						flash[:notice] = "Aircond state was successfuly changed. Mode: #{@aircond[:mode]},Temperature: #{@aircond[:temperature]}, Fan Speed : #{@aircond[:fan_speed]}"
						@path = root_path
					else
						flash[:warning] = "Aircond state was not change. Remains as #{@aircond.get_state[:status]}"
					end
				else
					flash[:warning] = 'Raspberry Pi might not be on.'
				end
			else
				flash[:warning] = "Invalid command signal"
			end
			respond_to do |format|
				format.html {
					redirect_to @path if @path == root_path
					redirect_to edit_aircond_path(@aircond) if @path == :edit
				}
				format.js {render 'signal.js.erb'}
			end
	end

	def assign_group
		@aircond.aircond_group_id = params[:aircond][:aircond_group_id]
		@aircond.save
	end



	def timer_set
		#sets the job for timer to execute
		trigger_time = Time.zone.parse(params.permit![:aircond][:timer])
		job = Sidekiq::Cron::Job.new(name:"AcTimer worker - #{@aircond.alias}", cron: " #{trigger_time.min} #{trigger_time.hour} * * 1-5 #{Time.zone.name}", class:'AcTimerWorker', args:{aircond_id:@aircond.id,status:params[:aircond][:status]})
		if job.save
			@aircond.update(timer:Time.zone.local_to_utc(trigger_time))
			redirect_to root_path
		else
			flash[:warning] = 'Invalid Job'
			redirect_to set_timer_path
		end
	end

	def set_all_status
		#sets all the aircond statuses..
		ac_grp = AircondGroup.find_by_title(params[:aircond][:group_title])
		ac_grp.nil? ? @airconds = Aircond.all : @airconds = ac_grp.airconds

		@airconds.each do |ac|
			ac.from_firebase = false
			# ac.send_signal(params[:status]) if ac.get_state[:status] != params[:status] 
			# ac.update(status:ac.get_state[:status])
			ac.update(status:params[:status])
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
		PaperTrail.whodunnit = params[:user_name]
		if validate_app_token(params[:user_name],params[:app_token])
			cmd = decipher_command(aircond_params)
			if validate_AC_controls(cmd)
				if @aircond.check_device_status
					if @aircond.check_power_status(aircond_params['status'])
						@aircond.update(aircond_params) 
						msg = "Aircond is already #{aircond_params[:status]}. Mode: #{aircond_params[:mode]},Temperature: #{aircond_params[:temperature]}, Fan Speed : #{aircond_params[:fan_speed]}"
					elsif @aircond.update(aircond_params) 
						msg = "Aircond state was successfuly changed. Mode: #{aircond_params[:mode]},Temperature: #{aircond_params[:temperature]}, Fan Speed : #{aircond_params[:fan_speed]}"
					else
						msg = "Aircond state was not change. Remains as #{@aircond.get_state[:status]}"
					end	
				else
					msg = 'Raspberry Pi might not be on.'
				end
			else
				msg = "Invalid command signal"
			end
		else
			msg = "Invalid Token"
		end
		render json:{response:msg}
	end

	def update_website_from_firebase
		PaperTrail.whodunnit = 'firebase'
		arguments = aircond_params
		sanitize_params(arguments)
		byebug
		@aircond.from_firebase = true
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
		@aircond.from_firebase = false
	end

	def sanitize_params(arguments)
		arguments[:temperature] = arguments[:temperature].to_i if !arguments[:temperature].nil?
		arguments[:fan_speed] = Aircond.fan_speeds[arguments[:fan_speed]]		
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
		elsif mode == nil
			@fan_speed_selection = []
			@temperature_selection = []
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
		token == app_token.access_token if !app_token.nil?
	end
end
class UsersController < Clearance::UsersController
	def dashboard
		Time.zone = current_user.timezone
		@current_time = Time.zone.now
		@airconds = Aircond.all.order(:id)
    @aircond_groups = AircondGroup.all
    @column_grid_length =4
	end

	def timeset
		current_user.timezone = params.permit![:user][:timezone]
		current_user.save
		redirect_to root_path
	end
end
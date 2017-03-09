class UsersController < Clearance::UsersController
	def dashboard
		@current_time = Time.zone.now
		@airconds = Aircond.all.order(:id)
    @aircond_groups = AircondGroup.not_empty
	end

end
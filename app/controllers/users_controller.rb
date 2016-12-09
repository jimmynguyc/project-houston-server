class UsersController < Clearance::UsersController
	def dashboard
		@airconds = Aircond.all
	end
end
namespace :start_app do
  desc "create only user"
  task user_create: :environment do
  	User.create(email:ENV['admin_email'],password:ENV['admin_password'],role:'admin')
  end
end


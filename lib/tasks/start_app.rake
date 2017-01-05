namespace :start_app do
  desc "create only user"
  task user_create: :environment do
  	User.create(email:ENV['user_email'],password:ENV['user_password'])
  end
end

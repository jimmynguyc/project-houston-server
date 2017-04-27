namespace :start_app do
  desc "create only user"
  task user_create: :environment do
  	User.create(email:ENV['admin_email'],password:ENV['admin_password'],role:'admin')
  end
end

namespace :status_checker do
  desc "sets workers to monitor and disable aircond status"
  task  set_worker: :environment do
    job = Sidekiq::Cron::Job.new(name:"AcStatusMonitor", cron: " * * * * 1-5 #{Time.zone.name}", class:'AcStatusMonitorWorker', args:{})
    job.save
  end
end
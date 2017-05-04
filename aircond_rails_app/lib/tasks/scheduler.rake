desc "This task is called by the Heroku scheduler add-on"
task :clear_logs => :environment do
  PaperTrail::Version.where('created_at <= ?', 1.week.ago).delete_all
end


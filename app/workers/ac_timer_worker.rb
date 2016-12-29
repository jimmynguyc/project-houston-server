class AcTimerWorker
  include Sidekiq::Worker

  def perform(*args)
  	#send specific state to specifc aircond
  	arguments = args[0]
  	puts "Ac Timer Worker Running!"
  	aircond = Aircond.find(arguments["aircond_id"])
    aircond.send_signal(status:arguments["status"])
  end
end

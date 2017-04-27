class AcStatusMonitorWorker
  include Sidekiq::Worker

  def perform(*args)
    #send specific state to specifc aircond
    firebase = Firebase::Client.new("https://nextaircon-6d849.firebaseio.com")
        
    Aircond.all.each do |aircond|
      aircond.check_device_status ? pi_state = "ENABLED" : pi_state = "DISABLED"
      firebase.update('/airconds/'+ aircond.id.to_s, {pi_status: state})
    end
  end
end

require 'unirest'

class Aircond < ApplicationRecord
	belongs_to :device
  belongs_to :aircond_group,  optional: true
	belongs_to :aircond_state,  optional: true
  has_paper_trail
  before_update :check_state
  after_save :update_firebase
  scope :by_aircond_group,  -> (ac_grp_id){where('aircond_group_id =  ?', ac_grp_id)}
  scope :by_unassigned_aircond_group,  -> {where('aircond_group_id IS NULL')}

  attr_accessor :from_firebase
	  enum status:{
	    'OFF' =>0,
	    'ON' =>1,
	    'PENDING' =>2
	  }

	  enum mode:{
	    'DRY' =>0,
	    'WET' =>1,
	    'COLD' => 2
	  }

	  enum fan_speed:{
	    'AUTO' =>0,
	    '1' =>1,
	    '2' =>2,
	    '3' =>3
	  }

	def get_state
		raspi = self.device
		path = raspi.url + "/state.py"
    response = Unirest.get(path,parameters:{access_token:raspi.access_token})
    #assumes that receive a hash {status:"ON"}
		return {status:true}
	end

	def send_signal(command)
		raspi = self.device
		path = raspi.url + "/state.py"
    params = {access_token: raspi.access_token, command:command}
		response = Unirest.post(path,parameters:params)

		check_power_status(self.changes['status'][1]) if self.changes.keys.include?(:status) && !self.changes[key].nil?
	end

	def update_firebase
    if from_firebase == false
  		firebase = Firebase::Client.new("https://nextaircon-6d849.firebaseio.com")
  		data = self.slice(:alias,:temperature,:mode,:fan_speed,:aircond_group_id)
      data[:pi_status] = "ENABLED"
  		firebase.update('/airconds/'+self.id.to_s, data)
    end
	end

   def check_state
     if from_firebase == false
       response = send_signal(get_command) if !(self.changes.keys & ["status","temperature","mode","fan_speed"]).empty?
       throw :abort if response == false
     end
   end

	def check_power_status(arg)
		get_state[:status] == arg
	end

	def check_device_status
     begin
       Unirest.get(self.device.url)
     rescue Errno::EHOSTUNREACH
       false
     else
			true
     end
	end

	def get_command
		data = self.slice(:status,:temperature, :mode, :fan_speed)
		data.keys.each do |key|
			data[key] = self.changes[key][1] if self.changes.keys.include? key
		end
		data = data.slice(:temperature,:mode, :fan_speed) if !self.changes.keys.include? 'status' || check_power_status(self.changes['status'][1])
		decipher_command(data)
	end

  def set_id
     response = Unirest.post(self.device.url + '/set_id.py',parameters:{id:self.id})
  end

  def formatted_timer(status,t_format=nil)
    case status
    when "ON"
      output = Time.zone.parse(self.timer_on.to_s)
    when "OFF"
      output = Time.zone.parse(self.timer_off.to_s)
    end
    output = output.strftime('%H:%M') if t_format == 'strf' && !output.nil?
    return output
  end

  def image_new(attribute)
  	value = self.send(attribute)
  	value = 'NA' if value == nil
  	case attribute
  		when :status
  			{img_url:"/NEXT-AC-assets/power-#{value.downcase}-01.png",value:value}
  		when :mode
				{img_url:"/NEXT-AC-assets/mode-#{value.downcase}-on.png",value:value}
  		when :fan_speed
  			{img_url:"/NEXT-AC-assets/speed-#{value.to_s.downcase}-on.png",value:value}
  		when :temperature
				{img_url:"/NEXT-AC-assets/temp-#{value.to_s}.png",value:value}
			end
  end
end


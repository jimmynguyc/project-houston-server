class AircondGroup < ApplicationRecord
  has_many :airconds
  validates :title, uniqueness: true
  accepts_nested_attributes_for :airconds
  # after_save :update_firebase

  def self.column_grid_length(divisor)
    if Aircond.by_unassigned_aircond_group.empty?
      length = 12/divisor
    else
      length = 12/(divisor+1)
    end

    if length < 3
      length = 3
    elsif length == 12
      length =6
    end
          
    return length
  end

  def self.filter_group_view(selection=nil)
    if selection == 'all'
      AircondGroup.all
    elsif selection
      AircondGroup.where(id:selection.to_i)
    else
      AircondGroup.not_empty
    end
  end

  def self.not_empty
    joins(:airconds).select('aircond_groups.*,count(airconds.id)').group('aircond_groups.id')
  end

  # def update_firebase
  #   firebase = Firebase::Client.new("https://nextaircon-6d849.firebaseio.com")
  #   data = self.slice(:title)
  #   firebase.update('/aircond_group/'+self.id.to_s, data)    
  # end
end



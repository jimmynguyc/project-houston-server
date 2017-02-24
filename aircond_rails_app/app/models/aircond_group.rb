class AircondGroup < ApplicationRecord
  has_many :airconds
  validates :title, uniqueness: true
  accepts_nested_attributes_for :airconds
  
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

  def self.populated_group_count
    count = 0
    AircondGroup.all.each do|ag| 
      count += 1 if !ag.airconds.empty?
    end
    return count
  end

  def self.all_group_count
    count = 0
    AircondGroup.all.each do|ag| 
      count += 1 
    end
    return count
  end  
end



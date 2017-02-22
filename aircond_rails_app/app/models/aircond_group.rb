class AircondGroup < ApplicationRecord
  has_many :airconds
  validates :title, uniqueness: true
  accepts_nested_attributes_for :airconds
  
  def self.column_grid_length
    if Aircond.by_unassigned_aircond_group.empty?
      length = 12/group_count
    else
      length = 12/(group_count+1)
    end

    length = 3 if length < 3 
    return length
  end

  def self.group_count
    count = 0
    AircondGroup.all.each do|ag| 
      count += 1 if !ag.airconds.empty?
    end
    return count
  end
end



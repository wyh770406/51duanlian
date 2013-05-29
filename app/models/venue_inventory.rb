class VenueInventory < ActiveRecord::Base
  belongs_to :gym
  belongs_to :venue_type

  validates :venue_type_id, uniqueness: { scope: :gym_id }

  attr_accessible :capacity, :venue_type, :venue_type_id

  default_value_for :capacity, 1
end

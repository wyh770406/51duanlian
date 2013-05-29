class Location < ActiveRecord::Base
  acts_as_gmappable check_process: false

  belongs_to :locatable, polymorphic: true
  belongs_to :area
  delegate :city, to: :area, allow_nil: true
  validates :address, :area, presence: true

  def full_address
    "#{city.name} #{area.name} #{address}"
  end

  def gmaps4rails_address
    full_address
  end
end

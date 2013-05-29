class VenueType < ActiveRecord::Base
  has_many :venue_inventories, dependent: :destroy
  has_many :gyms, through: :venue_inventories
  has_many :activities, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

class Area < ActiveRecord::Base
  belongs_to :city
  has_many :locations, dependent: :destroy

  validates :city, presence: true
  validates :name, presence: true, uniqueness: { scope: :city_id }
end

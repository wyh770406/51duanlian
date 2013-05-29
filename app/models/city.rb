class City < ActiveRecord::Base
  has_many :areas, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end

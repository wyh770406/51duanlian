class CardType < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :gym_groups
  has_many :gyms, through: :gym_groups
  has_many :cards

  validates :name, presence: true

  attr_accessible :name, :description, :company, :gym_group_ids
end

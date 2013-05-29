class GymGroup < ActiveRecord::Base
  attr_accessible :name, :company, :company_id

  belongs_to :company
  has_and_belongs_to_many :gyms
  has_and_belongs_to_many :card_types
end

class Company < ActiveRecord::Base
  attr_accessible :address, :name, :phone

  has_many :gym_groups, dependent: :destroy
  has_many :gyms, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :card_types, dependent: :destroy
  has_many :card_charges, dependent: :destroy
  has_many :cards
  has_many :card_line_items, through: :cards

  after_create :create_default_gym_group

  validates :name, presence: true, uniqueness: true

  protected

  def create_default_gym_group
    GymGroup.create(name: I18n.t('default_gym_group_name'), company: self)
  end
end

class Gym < ActiveRecord::Base
  belongs_to :company
  has_and_belongs_to_many :gym_groups
  has_many :card_types, through: :gym_groups
  has_many :cards, through: :card_types

  has_one :location, as: :locatable, dependent: :destroy
  has_many :images, class_name: "GymImage", order: "position", dependent: :destroy
  has_many :venue_inventories, dependent: :destroy
  has_many :venue_types, through: :venue_inventories
  has_many :activities, dependent: :destroy
  has_many :venues, through: :activities
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :csv_imports, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :location
  delegate :address, :zip_code, :full_address, to: :location
  # TODO: Add methods for following things:
  # delegate :card_types, :card_charges, :cards, to: :gym_group
  delegate :card_charges, to: :company

  accepts_nested_attributes_for :venue_types

  validates :name, presence: true, uniqueness: true
  validates :open_at, :close_at, :location, :venue_types, presence: true

  attr_accessible :name, :description, :phone, :open_at, :close_at, :location_attributes, :venue_type_ids, :gym_groups, :gym_group_ids, :company

  scope :confirmed, where('confirmed_at IS NOT NULL')
  scope :in_areas, lambda { |areas| includes(:location).where("locations.area_id" => areas.map(&:id)) }
  scope :name_contains, lambda { |name| where("name like ?", "%#{name}%") }

  def confirmed
    !!confirmed_at
  end

  def confirm
    self.confirmed_at = Time.now
    self.save
  end

  def deny
    self.confirmed_at = nil
    self.save
  end

  def key_image
    self.images.first
  end

  def business_hours
    "#{I18n.l(self.open_at, format: :time)} - #{I18n.l(self.close_at, format: :time)}"
  end
end

class Product < ActiveRecord::Base
  belongs_to :gym
  has_many :line_items, as: :purchasable

  validates :name, :count_on_hand, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :count_on_hand, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  attr_accessible :name, :description, :count_on_hand, :price, :sku, :gym

  default_scope where(:deleted_at => nil)

  def member_price
    price
  end

  def destroy
    self.update_attribute(:deleted_at, Time.now)
  end

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end
  
  def to_s(count = 1)
    if count > 1
      "#{self.name} x #{count}"
    else
      self.name
    end
  end

  def in_stock?
    self.count_on_hand > 0
  end
  alias in_stock in_stock?

  def out_of_stock?
    !self.in_stock?
  end

  def sufficient?(quantity)
    self.count_on_hand >= quantity
  end

  def unstock!(quantity)
    self.count_on_hand -= quantity
    self.save!
  end

  def restock!(quantity)
    self.count_on_hand += quantity
    self.save!
  end
end

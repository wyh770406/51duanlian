class CardCharge < ActiveRecord::Base
  belongs_to :company
  has_many :line_items, as: :purchasable

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  attr_accessible :name, :price, :company

  def member_price
    price
  end

  def to_s(count = 1)
    if count > 1
      "#{self.name} x #{count}"
    else
      self.name
    end
  end

  def in_stock?
    true
  end
  alias in_stock in_stock?

  def out_of_stock?
    false
  end

  def sufficient?(quantity)
    true
  end

  def unstock!(quantity)
  end

  def restock!(quantity)
  end

  def create_order(user, card, special_instructions = nil)
    order = Order::CardOrder.create(gym: self.company.gyms.first, user: user, card: card, special_instructions: special_instructions)
    order.populate([{ id: self.id, quantity: 1 }])
    order.fire_state_event(:complete)
    order
  end
end

class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :purchasable, :polymorphic => true

  def description
    self.purchasable.to_s(self.quantity)
  end

  def amount
    self.price * self.quantity
  end

  def member_amount
    self.member_price * self.quantity
  end

  def sufficient_stock?
    self.purchasable.sufficient? self.quantity
  end

  def insufficient_stock?
    !sufficient_stock?
  end

  def unstock_item!
    self.purchasable.unstock! self.quantity
  end

  def restock_item!
    self.purchasable.restock! self.quantity
  end

end

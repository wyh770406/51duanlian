class CardLineItem < ActiveRecord::Base
  belongs_to :card
  belongs_to :order

  scope :without_order, lambda { where('order_id is null') }

  validates :card, :amount, :validity, presence: true
  validates :validity, numericality: { greater_than_or_equal_to: 0 }

  default_value_for :validity, 0
  
  after_create :update_card!

  protected

  def update_card!
    card.update_balance!
    card.increase_validity!(self.validity)
  end
end

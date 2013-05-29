class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :source, polymorphic: true
  belongs_to :payment_method

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  attr_accessible :order, :amount, :source, :source_type, :source_id, :payment_method, :payment_method_id

  scope :by_card, lambda { where(source_type: 'Card') }

  after_save :update_order

	state_machine :state, initial: :pending do
    state :pending, :successful, :failed

    event :success do
      transition :pending => :successful
    end

    event :failure do
      transition :pending => :failed
    end
  end

  def pay!
    if self.state?(:pending)
      self.payment_method.capture(self)
    end
    self.state?(:successful)
  end

  protected

  def update_order
    order.payments.reload
    order.update!
  end

end

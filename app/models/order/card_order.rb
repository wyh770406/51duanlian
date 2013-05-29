class Order::CardOrder < Order
  belongs_to :card
  EXPIRE_SECONDS = 3600 * 24 * 3

  state_machine :state do
    after_transition :cart => :completed, :do => :add_expired_at
  end

  state_machine :payment_state do
    after_transition :balance_due => [:paid, :credit_owed], :do => [:remove_expired_at, :send_sms]
  end

  def populate(items_attributes)
    items_attributes.each do |attrs|
      card_charge = self.gym.card_charges.find(attrs[:id])
      line_item = LineItem.find_or_initialize_by_order_id_and_purchasable_type_and_purchasable_id(
        self.id,
        card_charge.class.to_s,
        card_charge.id
      )
      line_item.quantity ||= 0
      line_item.quantity += attrs[:quantity].to_i
      line_item.price = card_charge.price
      line_item.member_price = card_charge.member_price
      line_item.save!
    end
  end

  def update!
    super
    unless self.payable?
      self.card.process(self, self.total, 365)
    end
  end

  def denied_payment_methods
    ['PaymentMethod::Card']
  end

  def send_sms
    if self.card.mobile.present?
      SMSGateway.render_then_send(self.card.mobile, 'card_order', { order: self })
    end
  end

  protected

  def add_expired_at
    self.update_attribute(:expired_at, EXPIRE_SECONDS.seconds.since)
  end

  def remove_expired_at
    self.update_attribute(:expired_at, nil)
  end

  def self.initial
    'C'
  end
end
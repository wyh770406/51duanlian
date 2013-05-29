class Order::VenueOrder < Order
  EXPIRE_SECONDS = 900

  state_machine :state do
    after_transition :cart => :completed, :do => :add_expired_at
    after_transition :completed => :canceled, :do => :remove_expired_at
  end

  state_machine :payment_state do
    after_transition :balance_due => [:paid, :credit_owed], :do => [:remove_expired_at, :send_sms]
  end

  def populate(items_attributes)
    items_attributes.each do |attrs|
      venue = self.gym.venues.active.find(attrs[:id])
      purchasable = attrs[:real_venue_id] ? venue.real_venues.find(attrs[:real_venue_id]) : venue
      line_item = LineItem.find_or_initialize_by_order_id_and_purchasable_type_and_purchasable_id(
        self.id,
        purchasable.class.to_s,
        purchasable.id
      )
      line_item.quantity ||= 0
      line_item.quantity += attrs[:quantity].to_i
      line_item.price = venue.price
      line_item.member_price = venue.member_price
      line_item.save!
    end
  end

  def update_before_complete
    super
    self.generate_verification_code
  end

  def add_expired_at
    self.update_attribute(:expired_at, EXPIRE_SECONDS.seconds.since)
  end

  def remove_expired_at
    self.update_attribute(:expired_at, nil)
  end

  def send_sms
    SMSGateway.render_then_send(self.mobile, 'venue_order', { order: self })
  end

  protected

  def generate_verification_code
    self.verification_code = Array.new(6){rand(9)}.join
    self.verification_code
  end

  def self.initial
    'V'
  end
end

class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :gym
  has_many :line_items, dependent: :destroy
  has_many :payments, dependent: :destroy
  belongs_to :payment_method

  before_validation :generate_order_number, on: :create

  attr_accessible :username, :mobile, :special_instructions, :gym, :user, :card

  state_machine :state, initial: :cart do
    state :cart, :completed, :checked_in, :canceled, :refunded

    before_transition :cart => :completed, :do => :update_before_complete
    event :complete do
      transition :cart => :completed, :if => lambda { |order| order.sufficient_stock? }
    end
    after_transition :cart => :completed, :do => :update_after_complete

    event :check_in do
      transition :completed => :checked_in, :if => lambda { |order| !order.payment_state?(:balance_due) && order.is_a?(Order::VenueOrder) }
    end
    after_transition :completed => :checked_in, :do => :update_after_check_in

    event :cancel do
      transition [:completed, :checked_in] => :canceled
    end
    after_transition :completed => :canceled, :do => :update_after_canceled

    event :refund do
      transition [:canceled] => :refunded
    end

  end

  state_machine :payment_state, initial: :balance_due do
    state :balance_due, :paid, :credit_owed

    event :pay do
      transition :balance_due => same, :if => lambda { |order|
        order.member_payment_total < order.member_total && order.payment_total < order.total
      }
      
      transition :balance_due => :paid, :if => lambda { |order|
        (order.member_payment_total == order.member_total && order.member_payment_total == order.payment_total) || order.payment_total == order.total
      }
      
      transition :balance_due => :credit_owed, :if => lambda { |order|
        order.member_payment_total > order.member_total || order.payment_total > order.total
      }
    end
  end

  def generate_order_number
    record = true
    while record
      random = "#{self.class.initial}#{Array.new(9){rand(9)}.join}"
      record = self.class.where(number: random).first
    end
    self.number = random if self.number.blank?
    self.number
  end

  def empty?
    self.line_items.count == 0
  end

  def item_count
    self.line_items.map(&:quantity).sum
  end

  def amount
    self.line_items.map(&:amount).sum
  end

  def member_amount
    self.line_items.map(&:member_amount).sum
  end

  def sufficient_stock?
    !self.line_items.map(&:sufficient_stock?).include?(false)
  end

  def remained_to_pay(by_card = false)
    remained = if by_card
      self.member_total - self.member_payment_total
    else
      self.total - self.payment_total
    end
    remained > 0 ? remained : 0
  end

  def update!
    self.payment_total = self.payments.with_state(:successful).map(&:amount).sum
    self.fire_payment_state_event(:pay)
    self.payment_method = self.payments.with_state(:successful).order(:created_at).last.try(:payment_method)
    self.save!
  end

  def member_payment_total
    self.payments.with_state(:successful).by_card.map(&:amount).sum
  end

  def pay_via_card?
    (!payable?) && (member_payment_total == payment_total)
  end

  def payable?
    (state?(:completed) || state?(:checked_in)) && payment_state?(:balance_due)
  end

  def denied_payment_methods
    []
  end

  def paid_cards
    self.payments.with_state(:successful).by_card.map(&:source)
  end

  def refund_to_card(card, amount)
    if card.process(self, amount, 0, I18n.t(:refunded_from_order, number: self.number))
      fire_state_event(:refund)
      update_refund_total(amount)
    end
  end

  def refund_via_cash(amount)
    fire_state_event(:refund)
    update_refund_total(amount)
  end

  protected

  def update_refund_total(amount)
    self.refund_total ||= 0
    self.refund_total += amount
    self.save
  end

  def self.initial
    'R'
  end

  def update_before_complete
    self.total = self.amount
    self.member_total = self.member_amount
    self.payment_total = 0
    self.save
  end

  def update_after_complete
    unstock_items!
  end

  def update_after_check_in
    check_in_stamp!
  end

  def update_after_canceled
    restock_items!
  end

  def unstock_items!
    self.line_items.each do |line_item|
      line_item.unstock_item!
    end
  end

  def restock_items!
    self.line_items.each do |line_item|
      line_item.restock_item!
    end
  end

  def check_in_stamp!
    self.checked_in_at = Time.now
    self.save!
  end

  def self.cancel_expired!
    Order.where("expired_at <= ?", Time.now).each do |order|
      if order.payable?
        order.fire_state_event(:cancel)
        puts "Canceled order ##{order.number}."
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/#{File.basename(__FILE__, '.*')}/**/*.rb"].each { |f| require_dependency f }

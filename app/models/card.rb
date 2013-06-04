class Card < ActiveRecord::Base
  CARDS_ON_BATCH = 10

  belongs_to :company
  belongs_to :user
  has_many :card_line_items, dependent: :destroy
  has_many :payments, as: :source
  belongs_to :card_type

  validates :card_type, :number, :balance, :start_on, :stop_on, presence: true
  validates :username, :mobile, presence: true, unless: Proc.new { |r| r.sold_at.blank? }
  validates :mobile, presence: true, if: :check_mobile
  validates :number, uniqueness: { scope: :company_id }, format: { with: /^\S+$/ }
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  attr_accessible :company, :number, :username, :email, :mobile, :card_type_id, :card_type, :start_on, :stop_on, :validity, :user_id, :user

  default_value_for :balance, 0
  default_value_for :start_on, Date.today

  before_save :check_if_sold, :send_sms, :add_to_user

  delegate :gym_groups, :company, :gyms, to: :card_type
  delegate :card_charges, to: :company

  scope :available, lambda { where("start_on <= ? AND stop_on > ?", Date.today, Date.today) }
  scope :on_sale, lambda { where("sold_at is null") }
  scope :payable, lambda { |amount| where("balance > ?", amount) }
  scope :by_type, lambda { |t| where(card_type_id: t.id) }
  scope :by_gym, lambda { |gym| where(id: gym.card_ids) }

  def on_sale?
    self.sold_at.blank?
  end

  def available?
    (self.start_on <= Date.today) && (self.stop_on > Date.today)
  end

  def validity
    (self.start_on && self.stop_on) ? (self.stop_on - self.start_on).to_i : 0
  end

  def validity=(value)
    self.stop_on = self.start_on + value.to_i.days
  end

  def increase_validity(value = 1)
    self.stop_on = [self.stop_on, Date.today].max + value.to_i.days
  end

  def increase_validity!(value = 1)
    self.increase_validity(value)
    self.save!
  end

  def process(order, value, validity = 0, reason = nil)
    reason ||= order.number
    card_line_item = self.card_line_items.new(order: order, amount: value, reason: reason, validity: validity)
    card_line_item.save
  end

  def update!
    self.balance = self.card_line_items.map(&:amount).sum
    self.save!
  end

  def self.sell_to(card_type, contact_attrs)
    transaction do
      card = card_type.cards.on_sale.first
      return nil if card.blank?

      card.update_attributes(contact_attrs)
      if card.save
        return card
      else
        return nil
      end
    end
  end

  def self.batch_create(attrs)
    if all_numbers(attrs[:number]) && attrs[:username].blank? && attrs[:email].blank? && attrs[:mobile].blank?
      n = attrs[:number].to_i
      CARDS_ON_BATCH.times.map do |i|
        Card.create(attrs.merge({ number: n + i }))
      end
    else
      [Card.create(attrs)]
    end
  end

  def can_used_in?(gym)
    gyms.include?(gym)
  end

  protected

  def self.all_numbers(str)
    !!(str =~ /^[0-9]+$/)
  end

  def check_if_sold
    if sold_at.blank? and (username.present? or mobile.present? or email.present? or user.present?)
      self.sold_at = Time.now
    end
  end

  def send_sms
    if mobile_changed? && mobile.present?
      SMSGateway.render_then_send(mobile, 'card', { card: self })
    end
  end

  def add_to_user
    if mobile.present?
      u = User.mobile_verified.find_by_mobile(self.mobile)
      self.user = u unless u.blank?
    end
  end

  def check_mobile
    self.username.present?
  end   
end

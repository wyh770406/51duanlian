class Venue < ActiveRecord::Base
  belongs_to :activity
  has_many :real_venues, dependent: :destroy
  has_many :line_items, as: :purchasable

  default_value_for :active, false

  validates :start_at, :stop_at, :capacity, :count_on_hand, :activity, presence: true
  validates :capacity, :count_on_hand, numericality: { only_integer: true }

  delegate :gym, :venue_type, to: :activity

  scope :by_venue_type, lambda { |venue_type| includes(:activity).where("activities.venue_type_id = ?", venue_type.id) }
  scope :active, lambda { where(active: true) }
  scope :inactive, lambda { where(active: false) }
  scope :in_range, lambda { |start, stop| where("#{table_name}.start_at >= ? AND #{table_name}.stop_at <= ?", start, stop) }

  def self.around_times(target_time, backward_time, forward_time, max_backward, max_forward)
    {
      backwards: where(start_at: backward_time..(target_time - 1.second)).map(&:start_at).uniq.sort.reverse.take(max_backward).reverse,
      target: where(start_at: target_time).count > 0 ? [target_time] : [],
      forwards: where(start_at: (target_time + 1.second)..forward_time).map(&:start_at).uniq.sort.take(max_forward)
    }
  end

  def self.lowest_price(times)
    where(start_at: times).map{ |v| v.price }.min
  end

  def self.lowest_member_price(times)
    where(start_at: times).map{ |v| v.member_price }.min
  end

  def expired?
    self.stop_at < Time.now
  end

  def count_ordered
    self.capacity - self.count_on_hand
  end

  # TODO: Resign to_s for line item list
  def to_s(count = 1)
    I18n.t("venue_description",
      count: count,
      type: self.venue_type.name,
      date: I18n.l(self.start_at.to_date, format: :long),
      start_at: I18n.l(self.start_at, format: :time),
      stop_at: I18n.l(self.stop_at, format: :time)
    )
  end

  def to_line_item(quantity = 1)
    { 
      id: self.id,
      quantity: quantity
    }
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

  def update!
    unless self.real_venues.blank?
      self.count_on_hand = self.real_venues.on_hand.count
    end
    self.save!
  end

  def related_line_items
    if self.real_venues.count > 0
      self.real_venues.map{ |rv| rv.line_items }.flatten
    else
      self.line_items
    end
  end

  def publish!
    self.update_attributes(active: true)
  end
end

class RealVenue < ActiveRecord::Base
  belongs_to :venue
  has_many :line_items, as: :purchasable
  
  after_save :update_venue!

  scope :on_hand, where{ count_on_hand > 0 }
  scope :active, lambda { includes(:venue).where("#{Venue.table_name}.active IS TRUE") }
  scope :inactive, lambda { includes(:venue).where("#{Venue.table_name}.active IS FALSE") }

  def to_line_item(quantity = 1)
    { 
      id: self.venue.id,
      real_venue_id: self.id,
      quantity: quantity
    }
  end

  def to_s(count = 1)
    I18n.t("real_venue_description",
      count: count,
      type: self.venue.venue_type.name,
      date: I18n.l(self.venue.start_at.to_date, format: :long),
      start_at: I18n.l(self.venue.start_at, format: :time),
      stop_at: I18n.l(self.venue.stop_at, format: :time),
      id: self.id
    )
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
  
  protected

  def update_venue!
    self.venue.update!
  end

end

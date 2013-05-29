class VenueRule::PerCapitaRule < VenueRule
  store_accessor :settings, :price, :member_price, :max_people

  validates :price, :member_price, numericality: { greater_than_or_equal_to: 0 }
  validates :max_people, numericality: { only_integer: true, greater_than: 0 }

  def generate(*options)
    options = options.extract_options!
    venue = Venue.new(
      start_at: options[:start_at],
      stop_at: options[:stop_at],
      price: price,
      member_price: member_price,
      capacity: options[:quantity],
      count_on_hand: options[:quantity]
    )
    options[:quantity].times { venue.real_venues.build(count_on_hand: self.max_people, max_people: self.max_people) }
    venue
  end

end

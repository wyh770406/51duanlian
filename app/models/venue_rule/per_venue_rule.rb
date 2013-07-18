class VenueRule::PerVenueRule < VenueRule
  store_accessor :settings, :price, :member_price

  validates :price, :member_price, numericality: { greater_than_or_equal_to: 0 }

  def generate(*options)
    options = options.extract_options!
    Venue.new(
      start_at: options[:start_at],
      stop_at: options[:stop_at],
      price: price,
      member_price: member_price,
      capacity: options[:quantity],
      count_on_hand: options[:quantity]
    )
  end

  def build_from_params(params)
    venue = Venue.new(params)
    venue.count_on_hand = venue.capacity
    venue
  end  

end

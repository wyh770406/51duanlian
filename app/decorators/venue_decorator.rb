class VenueDecorator < ApplicationDecorator
  decorates :venue

  def on_date
    l_date(model.start_at.to_date)
  end

  def start_at
    l_time(model.start_at)
  end

  def stop_at
    l_time(model.stop_at)
  end

  def venue_type
    model.venue_type.name
  end

end
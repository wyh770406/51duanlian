module VenuesHelper
  def link_to_venues_at_time(gym, venue_type, time, classes = "btn")
    unless time.blank?
      link_to l(time, format: :time), search_gym_venues_path(gym, date: time.to_date, venue_type_id: venue_type.id), class: classes
    else
      link_to t("cannot_order_time"), '#', class: "#{classes} disabled"
    end
  end
end
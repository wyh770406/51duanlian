class VenuesController < BaseController
  skip_before_filter :authenticate_user!
  
  def search
    @gym = Gym.find(params[:gym_id])
    @date = Date.parse(params[:date])
    @venue_type = VenueType.find(params[:venue_type_id])

    @venues = Venue.includes(:activity).active.where("activities.gym_id" => @gym.id, "activities.venue_type_id" => @venue_type.id, :start_at => @date.beginning_of_day..@date.end_of_day).order(:start_at)
    @venue_groups = @venues.group_by { |v| { start_at: v.start_at, stop_at: v.stop_at } }
  end
end

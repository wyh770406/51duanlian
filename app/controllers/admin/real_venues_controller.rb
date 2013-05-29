module Admin
  class RealVenuesController < Admin::BaseController
    def index
      @venue = current_gym.venues.includes(:real_venues).find(params[:venue_id])
      @real_venues = @venue.real_venues
    end
  end
end

module Admin
  class VenuesController < Admin::BaseController
    def index
      @on_date = begin
        Date.parse(params[:on_date])
      rescue
        Date.today
      end
      @venue_type = begin
        VenueType.find(params[:venue_type_id])
      rescue
        current_gym.venue_types.first
      end
      @venues = current_gym.venues.includes(:activity).where('venues.active' => 1, 'activities.venue_type_id' => @venue_type.id, start_at: @on_date.to_time.all_day, stop_at: @on_date.to_time.all_day).order(:start_at, :stop_at)
      # TODO: group venues by start_at and stop_at
    end

    def publish
      @start = params[:start] ? Time.parse(params[:start]) : Time.zone.now
      @stop = Time.parse(params[:stop]).end_of_day

      Venue.transaction do
        current_gym.venues.inactive.in_range(@start, @stop).each do |venue|
          venue.publish!
        end
      end

      redirect_to admin_venues_path, notice: t("flash.admin.venues.publish.success", date: @stop.to_date.to_s)
    end
  end
end

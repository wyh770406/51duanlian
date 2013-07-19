module Admin
  class VenuesController < Admin::BaseController
    before_filter :load_activity, only: [:new, :create, :edit, :update, :disable, :manually]

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
      @venues = current_gym.venues.includes(:activity).available.where('activities.venue_type_id' => @venue_type.id, start_at: @on_date.to_time.all_day, stop_at: @on_date.to_time.all_day).order(:start_at, :stop_at)
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

    def new
      @activity = Activity.find(params[:activity_id])
      @venue = Venue.new(activity: @activity)
    end

    def create
      @venue = @activity.venue_rule.build_from_params(params[:venue])

      if @venue.save
        redirect_to admin_activity_path(@activity)
      else
        render action: "new"
      end
    end

    def edit
      @venue = @activity.venues.find(params[:id])
      @orders = @venue.related_completed_orders
    end

    def update
      @venue = @activity.venues.find(params[:id])

      if @venue.update_attributes(params[:venue])
        redirect_to admin_activity_path(@activity)
      else
        render action: "edit"
      end
    end

    def disable
      @venue = @activity.venues.find(params[:id])

      if @venue.can_disable?
        @venue.disable!(true)
        redirect_to admin_activity_path(@activity), notice: t("flash.admin.venues.disable.success")
      else
        redirect_to admin_activity_path(@activity), alert: t("flash.admin.venues.disable.failure")
      end
    end

    def disable_all
      @activity = current_gym.activities.find(params[:activity_id])
      params.each do |key, value|
        if key =~ /venue/
          venue = @activity.venues.find(value)
          if venue.can_disable?
            venue.disable!(true)
          end
        end
      end
      redirect_to admin_activity_path(@activity, begin_date: params[:begin_date], end_date: params[:end_date]), notice: t("flash.admin.venues.disable.success")
    end    

    def manually
      @venues = @activity.venues.manually
    end

    protected

    def load_activity
      @activity = current_gym.activities.find(params[:activity_id])
    end    
  end
end

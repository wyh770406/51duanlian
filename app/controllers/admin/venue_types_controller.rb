module Admin
  class VenueTypesController < Admin::BaseController
    skip_before_filter :check_current_gym

    def index
      @venue_types = VenueType.all
    end

    def new
      @venue_type = VenueType.new
    end

    def edit
      @venue_type = VenueType.find(params[:id])
    end

    def create
      @venue_type = VenueType.new(params[:venue_type])

      if @venue_type.save
        redirect_to admin_venue_types_path
      else
        render action: "new"
      end
    end

    def update
      @venue_type = VenueType.find(params[:id])

      if @venue_type.update_attributes(params[:venue_type])
        redirect_to admin_venue_types_path
      else
        render action: "edit"
      end
    end

    def destroy
      @venue_type = VenueType.find(params[:id])
      @venue_type.destroy

      redirect_to admin_venue_types_url
    end
  end
end
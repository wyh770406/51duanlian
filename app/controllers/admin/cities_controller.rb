module Admin
  class CitiesController < Admin::BaseController
    skip_before_filter :check_current_gym

    def index
      @cities = City.all
    end

    def new
      @city = City.new
    end

    def edit
      @city = City.find(params[:id])
    end

    def create
      @city = City.new(params[:city])

      if @city.save
        redirect_to admin_cities_url
      else
        render action: "new"
      end
    end

    def update
      @city = City.find(params[:id])

      if @city.update_attributes(params[:city])
        redirect_to admin_cities_url
      else
        render action: "edit"
      end
    end

    def destroy
      @city = City.find(params[:id])
      @city.destroy

      redirect_to admin_cities_url
    end
  end
end

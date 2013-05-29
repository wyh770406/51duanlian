module Admin
  class AreasController < Admin::BaseController
    skip_before_filter :check_current_gym

    def index
      @areas = Area.page(params[:page]).per(15)
    end

    def new
      @area = Area.new
    end

    def edit
      @area = Area.find(params[:id])
    end

    def create
      @area = Area.new(params[:area])

      if @area.save
        redirect_to admin_areas_url
      else
        render action: "new"
      end
    end

    def update
      @area = Area.find(params[:id])

      if @area.update_attributes(params[:area])
        redirect_to admin_areas_url
      else
        render action: "edit"
      end
    end

    def destroy
      @area = Area.find(params[:id])
      @area.destroy

      redirect_to admin_areas_url
    end
  end
end

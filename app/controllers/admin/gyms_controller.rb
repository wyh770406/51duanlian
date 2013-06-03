module Admin
  class GymsController < Admin::BaseController
    skip_before_filter :check_current_gym
    before_filter :find_gym_groups, only: [:new, :edit]

    def index
      @gyms = current_user.is?('admin') ? Gym.scoped : current_user.gyms
      @q = @gyms.search(params[:q])
      @gyms = @q.result.uniq.page(params[:page]).per(15)
    end

    def show
      @gym = GymDecorator.decorate(Gym.includes(:venue_types, :images).find(params[:id]))
      @images = @gym.images
    end

    def new
      @gym = Gym.new
      @gym.build_location
    end

    def edit
      @gym = Gym.find(params[:id])
      @gym_groups = @gym.company.gym_groups
    end

    def create
      @gym = Gym.new(params[:gym])
      @gym.users = [current_user]
      @gym.company = current_company
      
      if @gym.save
        redirect_to admin_gym_path(@gym)
      else
        render action: "new"
      end
    end

    def update
      @gym = Gym.find(params[:id])

      if @gym.update_attributes(params[:gym])
        redirect_to admin_gym_path(@gym)
      else
        render action: "edit"
      end
    end

    def destroy
      @gym = Gym.find(params[:id])
      @gym.destroy

      redirect_to admin_gyms_url
    end

    def confirm
      @gym = Gym.find(params[:id])
      if @gym.confirm
        redirect_to admin_gym_path(@gym), notice: t("flash.gyms.confirm.success")
      else
        redirect_to admin_gym_path(@gym), alert: t("flash.gyms.confirm.failure")
      end
    end

    def deny
      @gym = Gym.find(params[:id])
      if @gym.deny
        redirect_to admin_gym_path(@gym), notice: t("flash.gyms.deny.success")
      else
        redirect_to admin_gym_path(@gym), alert: t("flash.gyms.deny.failure")
      end
    end

    protected

    def find_gym_groups
      @gym_groups = current_company.try(:gym_groups)
    end
  end
end

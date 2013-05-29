module Admin
  class GymImagesController < Admin::BaseController
    skip_before_filter :check_current_gym
    before_filter :load_gym
    before_filter :merge_current_gym, only: [:create]

    def new
      @gym_image = @gym.images.build
    end

    def create
      @gym_image = GymImage.new(params[:gym_image])

      if @gym_image.save
        redirect_to admin_gym_path(@gym)
      else
        render action: "new"
      end
    end

    def destroy
      @gym_image = @gym.images.find(params[:id])
      @gym_image.destroy

      redirect_to admin_gym_path(@gym)
    end

    protected

    def load_gym
      # TODO: check user can manage the gym
      @gym = Gym.find(params[:gym_id])
    end

    def merge_current_gym
      if params[:gym_image]
        params[:gym_image].merge!(gym: @gym)
      end
    end
  end
end

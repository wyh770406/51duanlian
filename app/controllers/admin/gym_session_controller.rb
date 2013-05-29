module Admin
  class GymSessionController < Admin::BaseController
    skip_before_filter :check_current_gym
    skip_authorize_resource

    def update
      gym = Gym.find(params[:id])
      if gym
        session[:gym_id] = gym.id
        session[:company_id] = gym.company.id
        if gym.confirmed
          redirect_to admin_path, :notice => t('notice.entered_gym', gym: current_gym.name)
        else
          redirect_to admin_gym_path(gym), :notice => t('flash.base.current_gym.wait_confirmation')
        end
      else
        session[:gym_id] = nil
        redirect_to new_admin_gym_path, notice: t("flash.base.current_gym.nil")
      end
    end
  end
end
module Admin
  class GymGroupsController < Admin::BaseController
    skip_before_filter :check_current_gym
    before_filter :merge_current_company, only: [:create, :update]
    
    def index
      @gym_groups = current_company.gym_groups.page(params[:page]).per(15)
    end

    def show
      @gym_group = current_company.gym_groups.find(params[:id])
    end

    def new
      @gym_group = current_company.gym_groups.build
    end

    def edit
      @gym_group = current_company.gym_groups.find(params[:id])
    end

    def create
      @gym_group = GymGroup.new(params[:gym_group])
      @gym_group.company ||= current_user.company

      if @gym_group.save
        redirect_to admin_gym_group_path(@gym_group)
      else
        render action: "new"
      end
    end

    def update
      @gym_group = current_company.gym_groups.find(params[:id])

      if @gym_group.update_attributes(params[:gym_group])
        redirect_to admin_gym_group_path(@gym_group)
      else
        render action: "edit"
      end
    end

    def destroy
      @gym_group = current_company.gym_groups.find(params[:id])
      @gym_group.destroy

      redirect_to admin_gym_groups_url
    end

    protected

    def merge_current_company
      params[:gym_group].merge!(company: current_company)
    end
  end
end

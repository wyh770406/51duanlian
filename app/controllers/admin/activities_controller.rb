module Admin
  class ActivitiesController < Admin::BaseController
    before_filter :merge_current_gym, only: [:create, :update]
    before_filter :find_other_activities, only: [:new, :edit]

    def index
      @activities = ActivityDecorator.decorate current_gym.activities.roots.includes(:venue_type, :date_rule, :time_rule).page(params[:page]).per(15)
    end

    def show
      @activity = ActivityDecorator.decorate current_gym.activities.includes(:venue_type, :date_rule, :time_rule).find(params[:id])
    end

    def new
      @activity = current_gym.activities.build
      @activity.date_rule = RecurrenceRule::DateRule::WeeklyRule.new
      @activity.time_rule = RecurrenceRule::TimeRule::MinutelyRule.new
    end

    def edit
      @activity = current_gym.activities.find(params[:id])
      @other_activities = @other_activities.select { |a| (a != @activity) && !@activity.descendants.include?(a) }
    end

    def create
      @activity = Activity.new(params[:activity])

      if @activity.save
        redirect_to admin_activity_path(@activity)
      else
        render action: "new"
      end
    end

    def update
      @activity = current_gym.activities.find(params[:id])

      if @activity.update_attributes(params[:activity])
        redirect_to admin_activity_path(@activity)
      else
        render action: "edit"
      end
    end

    def destroy
      @activity = current_gym.activities.find(params[:id])
      @activity.destroy

      redirect_to admin_activities_url
    end

    def enable
      @activity = current_gym.activities.find(params[:id])
      @activity.enable

      redirect_to admin_activity_path(@activity)
    end

    def try_disable
      @activity = current_gym.activities.find(params[:id])
      @orders = @activity.future_orders
    end

    def disable
      @activity = current_gym.activities.find(params[:id])
      @activity.disable

      redirect_to admin_activity_path(@activity)
    end

    protected

    def merge_current_gym
      params[:activity].merge!(gym: current_gym)
    end

    def find_other_activities
      @other_activities = current_gym.activities.inactive
    end
  end
end

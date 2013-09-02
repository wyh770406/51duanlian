class GymsController < BaseController
  skip_before_filter :authenticate_user!
  before_filter :load_params, only: :search

  def search
    gyms_in_area = @venue_type.gyms.in_areas(@areas).name_contains(@gym_name)
    @gyms = gyms_in_area.map { |gym|
      venues = gym.venues.active.by_venue_type(@venue_type)
      times = venues.around_times(@target_time, @target_time - 2.hours, @target_time + 2.hours, 2, 2)
      unless times[:backwards].blank? && times[:target].blank? && times[:forwards].blank?
        {
          gym: gym,
          price: venues.lowest_price(times[:backwards] + times[:target] + times[:forwards]),
          member_price: venues.lowest_member_price(times[:backwards] + times[:target] + times[:forwards]),
          times: times
        }
      end
    }.compact
  end

  def show
    @gym = Gym.find(params[:id])
    @activity_max_published_to = @gym.activities.map{|activity| activity.published_to}.compact.max unless @gym.activities.empty?
  end

  def bookmark
    @gym = Gym.find(params[:id])
    current_user.bookmark(@gym)

    redirect_to gym_path(@gym)
  end

  def unbookmark
    @gym = Gym.find(params[:id])
    current_user.unbookmark(@gym)

    redirect_to bookmarked_gyms_path
  end

  def bookmarked
    @gyms = current_user.bookmarked_gyms
  end

  private

  def load_params
    @city = City.find(params[:city_id])
    @areas = unless params[:area_id].blank?
      @area = Area.find(params[:area_id])
      [@area]
    else
      @city.areas
    end
    @venue_type = VenueType.find(params[:venue_type_id])
    @gym_name = params[:gym_name]
    @date = Date.parse(params[:date])
    @time = params[:time]
    @target_time = Time.parse(@time).change(year: @date.year, month: @date.month, day: @date.day)
  end
end

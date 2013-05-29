module GymsHelper
  def bookmark_gym_button(gym)
    if user_signed_in?
      if current_user.bookmarked_gyms.include?(gym)
        link_to(t('bookmarked_gym'), '#', class: 'btn disabled')
      else
        link_to(t('bookmark_gym'), bookmark_gym_path(gym), class: 'btn btn-primary', method: :post)
      end
    end
  end
end
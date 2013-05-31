class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t("cancan_access_denied")
  end

  def after_sign_in_path_for(resource)
    if resource.backend?
      admin_path
    else
      if resource.mobile_verified?
        stored_location_for(resource) || root_path
      else
        edit_mobile_path
      end
    end
  end
end

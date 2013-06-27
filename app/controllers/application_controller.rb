class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t("cancan_access_denied")
  end

  if Rails.env.production?
   unless Rails.application.config.consider_all_requests_local
     rescue_from Exception, with: :render_500
   end
  end

  def render_500(exception)
    logger.info exception.backtrace.join("\n")
    respond_to do |format|
      format.html { render template: 'errors/internal_server_error', layout: 'layouts/admin', status: 500 }
      format.all { render nothing: true, status: 500}
    end
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

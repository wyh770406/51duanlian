module Admin
  class DashboardController < Admin::BaseController
    skip_authorize_resource
    authorize_resource class: false

    def index
      redirect_to admin_orders_path
    end

  end
end

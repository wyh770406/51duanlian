module Admin
  class CheckoutsController < Admin::BaseController
    skip_authorize_resource
    authorize_resource class: false
    
    def edit
      @order = current_order

      if @order.empty?
        redirect_to edit_admin_cart_path, alert: t("flash.checkouts.edit.empty")
      end
    end

    def update
      @order = current_order
      params[:order] ||= {}
      params[:order].merge!(user: current_user)
      
      if @order.update_attributes(params[:order])
        if @order.fire_state_event(:complete)
          after_complete
          redirect_to admin_order_path(@order)
        else
          redirect_to edit_admin_checkout_path
        end
      else
        redirect_to edit_admin_checkout_path
      end
    end

    protected

    def after_complete
      session[:order_id] = nil
    end
  end
end

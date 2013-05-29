class CheckoutsController < BaseController

  def update
    @order = current_order
    params[:order] ||= {}
    params[:order].merge!(user: current_user)
    
    if @order.empty?
      redirect_to edit_cart_path, alert: t("flash.checkouts.edit.empty")
    else
      if @order.update_attributes(params[:order])
        if @order.fire_state_event(:complete)
          after_complete
          redirect_to order_path(@order)
        else
          redirect_to edit_cart_path
        end
      else
        redirect_to edit_cart_path
      end
    end
  end

  protected

  def after_complete
    session[:order_id] = nil
  end
end

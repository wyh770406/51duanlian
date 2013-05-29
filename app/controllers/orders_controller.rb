class OrdersController < BaseController
  def index
    begin
      params[:q][:created_at_lteq] = Date.parse(params[:q][:created_at_lteq]).end_of_day unless params[:q][:created_at_lteq].blank?
    rescue
    end

    @q = current_user.orders.without_state([:cart, :canceled]).search(params[:q])
    @orders = @q.result(distinct: true).order("updated_at DESC")
  end

  def show
    @order = current_user.orders.find(params[:id])
    @payment_methods = PaymentMethod.available('front_end').exclude_type(@order.denied_payment_methods)
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.fire_state_event(:cancel)

    redirect_to orders_url
  end
end

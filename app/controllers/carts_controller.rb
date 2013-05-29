class CartsController < BaseController
  skip_before_filter :authenticate_user!, only: [:populate]
  respond_to :js, only: [:populate]
  
  def populate
    if user_signed_in? && Order.subclasses.map(&:to_s).include?(params[:type])
      @gym = Gym.find(params[:gym_id])
      @order = current_order(true, params[:type], @gym)
      @order.populate(params[:items_attributes])
    end
  end

  def edit
    @order = current_order(true)
  end

  def empty
    if @order = current_order
      @order.line_items.destroy_all
    end

    redirect_to edit_cart_path
  end
end

module Admin
  class OrdersController < Admin::BaseController
    before_filter :merge_current_gym, only: [:update]

    def index
      @order_klass = params[:order_klass] || params[:q].try(:[], :type_eq) || 'Order::VenueOrder'
      @order_klass = Order.subclasses.first.to_s unless Order.subclasses.map(&:to_s).include?(@order_klass)
      params[:q] = { state_eq: 'completed' } if params[:q].nil?
      params[:q][:type_eq] = @order_klass
      begin
        params[:q][:created_at_lteq] = Date.parse(params[:q][:created_at_lteq]).end_of_day unless params[:q][:created_at_lteq].blank?
      rescue
      end
      
      @q = current_gym.orders.without_state(:cart).search(params[:q])
      @orders = @q.result(distinct: true).order("updated_at DESC").page(params[:page]).per(15)
    end

    def show
      @order = current_gym.orders.find(params[:id])
      @payment_methods = PaymentMethod.available('back_end').exclude_type(@order.denied_payment_methods)
    end

    def edit
      @order = current_gym.orders.find(params[:id])
    end

    def update
      @order = current_gym.orders.find(params[:id])

      if @order.update_attributes(params[:order])
        redirect_to admin_order_path(@order)
      else
        render action: "edit"
      end
    end

    def cancel
      @order = current_gym.orders.find(params[:id])
      @order.fire_state_event(:cancel)

      redirect_to admin_order_path(@order)
    end

    def check_in
      @order = current_gym.orders.find(params[:id])
      if @order.fire_state_event(:check_in)
        flash[:notice] = t("flash.orders.check_in.success", number: @order.number)
      else
        flash[:alert] = t("flash.orders.check_in.failure", number: @order.number)
      end

      redirect_to admin_orders_url
    end

    def new_refund
      @order = current_gym.orders.find(params[:id])
      @cards = @order.paid_cards
      @amount = @order.payment_total
    end

    def refund
      @order = current_gym.orders.find(params[:id])
      @card = current_gym.cards.find(params[:card_id]) unless params[:card_id].blank?
      @amount = BigDecimal.new(params[:amount])

      if @amount > 0
        if @card
          @order.refund_to_card(@card, @amount)
        else
          @order.refund_via_cash
        end
        flash[:notice] = t("flash.orders.refund.success", number: @order.number)
      else
        flash[:alert] = t("flash.orders.refund.failure", number: @order.number)
      end
      
      redirect_to admin_order_path(@order)
    end

    def destroy
      @order = current_gym.orders.find(params[:id])
      @order.destroy

      redirect_to admin_orders_url
    end

    protected

    def merge_current_gym
      params[:order].merge!(gym: current_gym)
    end

  end
end

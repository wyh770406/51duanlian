# encoding: utf-8
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

      @q_condition = params[:q]
      
      @q = current_gym.orders.without_state(:cart).search(params[:q])
      @orders = @q.result(distinct: true).order("updated_at DESC").page(params[:page]).per(15)
    end

    def export_pdf
      @order_klass = params[:order_klass] || params[:q].try(:[], :type_eq) || 'Order::VenueOrder'
      @order_klass = Order.subclasses.first.to_s unless Order.subclasses.map(&:to_s).include?(@order_klass)
      params[:q] = { state_eq: 'completed' } if params[:q].nil?
      params[:q][:type_eq] = @order_klass

      begin
        params[:q][:created_at_gteq] = Date.parse(params[:q][:created_at_gteq]).beginning_of_day unless params[:q][:created_at_gteq].blank?
        params[:q][:created_at_lteq] = Date.parse(params[:q][:created_at_lteq]).end_of_day unless params[:q][:created_at_lteq].blank?
      rescue
      end

      start_date = params[:q][:created_at_gteq].blank? ? "空" : params[:q][:created_at_gteq].strftime('%Y-%m-%d')
      end_date = params[:q][:created_at_lteq].blank? ? "空" : params[:q][:created_at_lteq].strftime('%Y-%m-%d')

      order_number = params[:q][:number_cont].blank? ? "空" : params[:q][:number_cont]
      order_state = params[:q][:state_eq].blank? ? "全部" : Order.send("human_state_name", params[:q][:state_eq])
      order_mobile = params[:q][:mobile_cont].blank? ? "空" : params[:q][:mobile_cont]
      order_payment_state = params[:q][:payment_state_eq].blank? ? "全部" : Order.send("human_payment_state_name", params[:q][:payment_state_eq])
      order_payment_method = params[:q][:payment_method_id_eq].blank? ? "全部" :
        ([[t('all'), '']] + PaymentMethod.available.map { |m| [m.name, m.id] }).find{|payment_method| payment_method[1]==params[:q][:payment_method_id_eq].to_i}[0]

      @q_condition_date_range = "下单时间范围: #{start_date}(起始日期) / #{end_date}(终止日期)"
      @q_condition_number = "订单号: #{order_number}"
      @q_condition_state = "状态: #{order_state}"
      @q_condition_mobile = "手机号: #{order_mobile}"
      @q_condition_payment_state = "支付状态: #{order_payment_state}"
      @q_condition_payment_method = "支付方式: #{order_payment_method}"

      @q = current_gym.orders.without_state(:cart).search(params[:q])
      @orders = @q.result(distinct: true).order("updated_at DESC")

      @order_totals = 0
      @orders.each do |order|
        order_total = order.payable? ? order.total : order.payment_total
        @order_totals += order_total
      end

      @order_payment_totals = @orders.map(&:payment_total).sum

      respond_to do |format|
        format.pdf do
          render :pdf => "test.pdf",
                 :template => "admin/orders/export_pdf.pdf.erb"
        end
      end
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
          @order.refund_via_cash(@amount)
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

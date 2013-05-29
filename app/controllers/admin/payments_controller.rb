module Admin
  class PaymentsController < Admin::BaseController
    skip_before_filter :authenticate_user!, only: [:notify, :done]
    before_filter :load_order

    def new
      @payment_method = PaymentMethod.find(params[:payment_method_id])
      @payment = @payment_method.build_payment_for(@order)
    end

    def create
      @payment = Payment.new(params[:payment].merge(order: @order))
      @payment_method = @payment.payment_method

      if @payment.save
        @payment.pay!

        case @payment.state_name
        when :successful
          redirect_to admin_order_path(@order), notice: t("flash.payments.create.successful")
        when :failed
          redirect_to admin_order_path(@order), alert: t("flash.payments.create.failed")
        else
          redirect_to pay_admin_order_payment_path(@order, @payment)
        end
      else
        render "new"
      end
    end

    def pay
      @payment = Payment.find(params[:id])
      @payment_method = @payment.payment_method
    end
    
    def notify
      @payment = Payment.find(params[:id])
      @payment_method = @payment.payment_method

      @payment_method.process_notification(request.raw_post, @payment)
      @payment.pay!

      case @payment.state_name
      when :successful
        redirect_to admin_order_path(@order), notice: t("flash.payments.create.successful")
      when :failed
        redirect_to admin_order_path(@order), alert: t("flash.payments.create.failed")
      else
        redirect_to pay_admin_order_payment_path(@order, @payment)
      end
    end

    def done
      @payment = Payment.find(params[:id])
      @payment_method = @payment.payment_method

      @payment_method.process_return(request.query_string, @payment)
      @payment.pay!

      case @payment.state_name
      when :successful
        redirect_to admin_order_path(@order), notice: t("flash.payments.create.successful")
      when :failed
        redirect_to admin_order_path(@order), alert: t("flash.payments.create.failed")
      else
        redirect_to pay_admin_order_payment_path(@order, @payment)
      end
    end

    protected

    def load_order
      @order = current_gym.orders.find(params[:order_id])
    end
  end
end

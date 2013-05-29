module Admin
  class PaymentMethodsController < Admin::BaseController
    skip_before_filter :check_current_gym
    
    def index
      @payment_methods = PaymentMethod.page(params[:page]).per(15)
    end

    def show
      @payment_method = PaymentMethod.find(params[:id])
    end

    def new
      @payment_method = PaymentMethod.new
    end

    def edit
      @payment_method = PaymentMethod.find(params[:id])
    end

    def create
      @payment_method = PaymentMethod.new(params[:payment_method])

      if @payment_method.save
        redirect_to admin_payment_method_path(@payment_method)
      else
        render action: "new"
      end
    end

    def update
      @payment_method = PaymentMethod.find(params[:id])

      if @payment_method.update_attributes(params[:payment_method])
        redirect_to admin_payment_method_path(@payment_method)
      else
        render action: "edit"
      end
    end

    def destroy
      @payment_method = PaymentMethod.find(params[:id])
      @payment_method.destroy

      redirect_to admin_payment_methods_url
    end
  end
end

module Admin
  class CartsController < Admin::BaseController
    skip_authorize_resource
    authorize_resource class: false
    before_filter :load_back_to_url
    
    def show

    end

    def populate
      # Check for security class
      if Order.subclasses.map(&:to_s).include?(params[:type])
        @order = current_order(true, params[:type])
        @order.populate(params[:items_attributes])
      end
      redirect_to edit_admin_cart_path(back_to_url: @back_to_url)
    end

    def edit
      @order = current_order(true)
    end

    def update

    end

    def empty
      if @order = current_order
        @order.line_items.destroy_all
      end

      redirect_to edit_admin_cart_path(back_to_url: @back_to_url)
    end

    protected

    def load_back_to_url
      @back_to_url = params[:back_to_url] || root_url
    end
  end
end

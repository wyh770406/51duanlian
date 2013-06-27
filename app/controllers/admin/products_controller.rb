module Admin
  class ProductsController < Admin::BaseController

    before_filter :merge_current_gym, only: [:create, :update]

    def index
      @products = current_gym.products
      @q = @products.search(params[:q])
      @products = @q.result.page(params[:page]).per(15)
    end

    def new
      @product = current_gym.products.build
    end

    def edit
      @product = current_gym.products.find(params[:id])
    end

    def create
      @product = Product.new(params[:product])

      if @product.save
        redirect_to admin_products_url
      else
        render action: "new"
      end
    end

    def update
      @product = current_gym.products.find(params[:id])

      if @product.update_attributes(params[:product])
        redirect_to admin_products_url
      else
        render action: "edit"
      end
    end

    def destroy
      @product = current_gym.products.find(params[:id])
      @product.destroy

      redirect_to admin_products_url
    end

    def clear_products
      current_gym.products.each do |product|
        product.destroy
      end
      redirect_to admin_products_url
    end

    protected

    def merge_current_gym
      params[:product].merge!(gym: current_gym)
    end
  end
end

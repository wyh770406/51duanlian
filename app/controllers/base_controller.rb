class BaseController < ApplicationController
  before_filter :authenticate_user!
  
  # The current incompleted order from the session for use in cart and during checkout
  def current_order(create_order_if_necessary = false, order_class_name = 'Order', gym = nil)
    order_klass = order_class_name.safe_constantize
    return @current_order if @current_order and @current_order.is_a? order_klass

    if session[:order_id]
      unless gym.blank?
        @current_order = order_klass.find_by_id_and_gym_id(session[:order_id], gym.id)
      else
        @current_order = order_klass.find(session[:order_id])
      end
    end

    if create_order_if_necessary and (@current_order.nil? or @current_order.completed? or (not @current_order.is_a? order_klass))
      @current_order = order_klass.new(gym: gym, username: current_user.name, mobile: current_user.mobile)
      @current_order.save!
    end
    session[:order_id] = @current_order ? @current_order.id : nil
    @current_order
  end

  helper_method :current_order
  
end

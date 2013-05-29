class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!, :check_role, :check_current_gym, :check_current_company
  authorize_resource
  layout 'admin'

  def check_role
    unless current_user.backend?
      redirect_to root_path
    end
  end

  def current_company
    begin
      if can?(:manage, Company)
        @current_company ||= Company.find(session[:company_id])
      else
        session[:company_id] ||= current_user.company.id
        @current_company ||= current_user.company
      end
    rescue
      nil
    end
  end

  def current_gym
    begin
      if current_user.is?('admin')
        @current_gym ||= Gym.confirmed.find(session[:gym_id])
      else
        @current_gym ||= current_user.gyms.confirmed.find(session[:gym_id])
      end
    rescue
      nil
    end
  end

  helper_method :current_company, :current_gym

  # The current incompleted order from the session for use in cart and during checkout
  def current_order(create_order_if_necessary = false, order_class_name = 'Order')
    order_klass = order_class_name.safe_constantize
    return @current_order if @current_order and @current_order.is_a? order_klass
    if session[:order_id]
      @current_order = order_klass.find_by_id_and_gym_id(session[:order_id], current_gym.try(:id))
    end
    if create_order_if_necessary and (@current_order.nil? or @current_order.completed? or (not @current_order.is_a? order_klass))
      @current_order = order_klass.new(gym: current_gym)
      @current_order.save!
    end
    session[:order_id] = @current_order ? @current_order.id : nil
    @current_order
  end

  helper_method :current_order

  def check_current_company
    unless can?(:manage, Company) || current_company
      redirect_to new_admin_company_path, notice: t("flash.base.current_company.nil")
    end
  end

  def check_current_gym
    unless current_gym
      if current_user.is?('admin') || current_user.gyms.count > 1
        redirect_to admin_gyms_path
      elsif current_user.gyms.count == 1
        redirect_to controller: 'gym_session', action: 'update', id: current_user.gyms.first
      else
        redirect_to new_admin_gym_path, notice: t("flash.base.current_gym.nil")
      end
    end
  end
end

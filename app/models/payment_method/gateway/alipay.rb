class PaymentMethod::Gateway::Alipay < PaymentMethod::Gateway

  store_accessor :settings, :gateway_id, :gateway_key, :gateway_user

  def self.instanceable?
    true
  end

  def gateway_service
    :alipay
  end

  def gateway_service_type
    ActiveMerchant::Billing::Integrations::Alipay::Helper::CREATE_DIRECT_PAY_BY_USER
  end

  def gateway_payment_type
    1
  end

  def process_notification(query, payment)
    notification = ActiveMerchant::Billing::Integrations::Alipay::Notification.new(query)

    gateway_bill = GatewayBill.find_or_create_by_notification_id(notification.notify_id) do |gb|
      gb.transaction do
        if gb.pending?
          gb.successful = notification.acknowledge(gateway_key)
          gb.trade_state = notification.trade_status
          gb.trade_number = notification.trade_no
          gb.notified_at = notification.notify_time
          gb.customer = notification.buyer_email
        end
      end
    end

    if payment.source.blank?
      payment.source = gateway_bill
      payment.save
    end
  end

  def process_return(query, payment)
    result = ActiveMerchant::Billing::Integrations::Alipay::Return.new(query)
    params = result.params.with_indifferent_access

    gateway_bill = GatewayBill.find_or_create_by_notification_id(params[:notify_id]) do |gb|
      gb.transaction do
        if gb.pending?
          gb.successful = result.success?(gateway_key)
          gb.trade_state = params[:trade_status]
          gb.trade_number = params[:trade_no]
          gb.notified_at = params[:notify_time]
          gb.customer = params[:buyer_email]
        end
      end
    end

    if payment.source.blank?
      payment.source = gateway_bill
      payment.save
    end
  end

  protected

  def computable?(payment)
    payment.source.present?
  end

  def compute(payment)
    payment.source.successful
  end

  private

  def mass_assignment_authorizer(role = :default)
    super + [:gateway_id, :gateway_key, :gateway_user]
  end
end
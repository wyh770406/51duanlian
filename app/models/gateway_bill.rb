class GatewayBill < ActiveRecord::Base
  has_one :payment, as: :source
  attr_accessible :customer, :notification_id, :notified_at, :trade_number, :trade_state, :successful

  def pending?
    successful.nil?
  end
end

class PaymentMethod::Card < PaymentMethod

  def self.instanceable?
    true
  end

  def build_payment_for(order)
    order.payments.build(payment_method: self, amount: order.remained_to_pay(true))
  end

  protected

  def compute(payment)
    if payment.source && payment.source.is_a?(::Card) && (payment.source.can_used_in?(payment.order.gym))
      payment.order.update_attribute(:username, payment.source.username) if payment.order.username.blank? && payment.source.username.present?
      payment.order.update_attribute(:mobile, payment.source.mobile) if payment.order.mobile.blank? && payment.source.mobile.present?
      payment.source.process(payment.order, -payment.amount)
    else
      false
    end
  end

end
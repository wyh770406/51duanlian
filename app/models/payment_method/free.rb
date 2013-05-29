class PaymentMethod::Free < PaymentMethod

  def self.instanceable?
    true
  end

  protected

  def compute(payment)
    true
  end
end
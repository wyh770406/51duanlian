class PaymentMethod::Gateway < PaymentMethod

  def self.instanceable?
    false
  end

end
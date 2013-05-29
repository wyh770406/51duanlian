class PaymentMethod < ActiveRecord::Base
  has_many :payments

  DISPLAY =  [:both, :front_end, :back_end]

  store :settings

  validates :type, :name, presence: true

  attr_accessible :type, :name, :display_on, :active

  default_scope where(:deleted_at => nil)
  scope :exclude_type, lambda { |t| where{type.not_in t} }

  def self.instanceable?
    false
  end

  def self.available(only_display_on = 'both')
    if only_display_on == 'both' || only_display_on.blank?
      where{(active == true)}
    else
      where{(active == true) & ((display_on == only_display_on) | (display_on == ''))}
    end
  end

  def self.active?
    self.count(:conditions => { :type => self.to_s, :active => true }) > 0
  end

  def method_type
    type.demodulize.downcase
  end

  def destroy
    self.update_attribute(:deleted_at, Time.now)
  end

  def self.find_with_destroyed *args
    self.with_exclusive_scope { find(*args) }
  end

  def capture(payment)
    begin
      return unless computable?(payment)
      
      if compute(payment)
        after_success(payment)
      else
        after_failure(payment)
      end
    rescue
    end
  end

  def build_payment_for(order)
    order.payments.build(payment_method: self, amount: order.remained_to_pay)
  end

  protected

  def computable?(payment)
    true
  end

  def compute(payment)
    raise(NotImplementedError, 'please use concrete payment method')
  end

  def after_success(payment)
    payment.fire_state_event(:success)
  end

  def after_failure(payment)
    payment.fire_state_event(:failure)
  end
end

Dir["#{File.dirname(__FILE__)}/#{File.basename(__FILE__, '.*')}/**/*.rb"].each { |f| require_dependency f }

class PaymentMethod
  def self.payment_method_classes
    klasses = [PaymentMethod]
    index = 0
    while klasses[index]
      klasses += klasses[index].subclasses
      index += 1
    end
    klasses.select { |c| c.instanceable? }
  end
end

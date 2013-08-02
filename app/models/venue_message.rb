class VenueMessage < ActiveRecord::Base
  belongs_to :gym
  attr_accessible :mobile, :gym
  after_save :send_sms
  
  protected

  def send_sms
    SMSGateway.render_then_send(self.mobile, 'venue_sms', { cgym: self.gym })
  end
end

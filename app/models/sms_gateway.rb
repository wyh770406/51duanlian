require 'net/http'

class SMSGateway
  SMS_GATEWAY_URL = "http://esms.etonenet.com/sms/mt"
  SMS_GATEWAY_USERNAME = "7891"
  SMS_GATEWAY_PASSWORD = "123123"
  SMS_GATEWAY_ENABLED = Rails.env.production?

  def self.send(phone, message)
    unless SMS_GATEWAY_ENABLED
      puts "Send SMS to #{phone}: #{message}"
      return true
    end
    
    params = {
      command: "MT_REQUEST",
      spid: SMS_GATEWAY_USERNAME,
      sppassword: SMS_GATEWAY_PASSWORD,
      da: "86#{phone}",
      dc: encoding,
      sm: encode(message)
    }
    url = "#{SMS_GATEWAY_URL}?#{params.to_param}"

    post(url)
  end

  def self.render_then_send(phone, name, params = {})
    message = render(name, params).strip
    send(phone, message)
  end

  protected

  def self.render(name, params = {})
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(file: "sms/#{name}", locals: params)
  end

  def self.post(url)
    begin
      uri = URI(url)
      res = Net::HTTP.get(uri)
      return CGI.parse(res)['mterrcode'][0] == "000"
    rescue
      return false
    end
  end

  def self.encoding
    "8"
  end

  def self.encode(message)
    message.encode("UTF-16BE").bytes.to_a.map { |i| "%02x" % i }.join
  end
end
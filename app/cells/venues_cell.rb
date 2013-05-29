class VenuesCell < Cell::Rails
  helper FormHelper

  def search(options = {})
    @options = options
    @options[:date] ||= Date.today
    @options[:time] ||= 1.hour.since.strftime('%H:00')

    render
  end

end

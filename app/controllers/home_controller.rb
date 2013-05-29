class HomeController < BaseController
  skip_before_filter :authenticate_user!
  
  def index
  end
end

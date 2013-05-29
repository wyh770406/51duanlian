class UserAgreementsController < BaseController
  skip_before_filter :authenticate_user!
  
  def index
  	@user_agreement = UserAgreement.first
  end
end
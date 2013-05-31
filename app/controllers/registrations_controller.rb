class RegistrationsController < Devise::RegistrationsController
  
  def new
    @role = params[:role]
    @agreement = @role ? UserAgreement.find(2) : UserAgreement.first
  	super
  end

  def create
    @role = params[:role]
    @agreement = @role ? UserAgreement.find(2) : UserAgreement.first
  	super
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path(resource)
  end
end
module Admin
  class UserAgreementsController < Admin::BaseController
    skip_before_filter :check_current_gym
    
    def index
      @user_agreements = UserAgreement.all
    end

    def edit
      @user_agreement = UserAgreement.find(params[:id])
    end

    def update
      @user_agreement = UserAgreement.find(params[:id])

      if @user_agreement.update_attributes(params[:user_agreement])
        redirect_to admin_user_agreements_path
      else
        render action: "edit"
      end
    end

  end
end
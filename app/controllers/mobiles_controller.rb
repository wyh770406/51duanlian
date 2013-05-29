class MobilesController < BaseController
  def edit
    @mobile = current_user.mobile
  end

  def update
    if current_user.verify_mobile(params[:code])
      redirect_to edit_profile_path, notice: t("flash.mobiles.update.success")
    else
      redirect_to edit_profile_path, alert: t("flash.mobiles.update.failure")
    end
  end

  def send_verification_code
    current_user.send_mobile_verification_sms
    redirect_to edit_mobile_path, notice: t("flash.mobiles.send_verification_code.success")
  end
end
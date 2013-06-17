class ContactsController < BaseController
  skip_before_filter :authenticate_user!
  
  def show
  	@id = params[:id]
  	@contact = Contact.find(params[:id])
  end
end
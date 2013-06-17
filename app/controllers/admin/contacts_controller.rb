module Admin
  class ContactsController < Admin::BaseController
    skip_before_filter :check_current_gym
    
    def index
      @contacts = Contact.all
    end

    def edit
      @contact = Contact.find(params[:id])
    end

    def update
      @contact = Contact.find(params[:id])

      if @contact.update_attributes(params[:contact])
        redirect_to admin_contacts_path
      else
        render action: "edit"
      end
    end

  end
end
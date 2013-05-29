module Admin
  class CardChargesController < Admin::BaseController
    skip_before_filter :check_current_gym
    before_filter :merge_current_company, only: [:create, :update]

    def index
      @card_charges = current_company.card_charges.all
    end

    def show
      @card_charge = current_company.card_charges.find(params[:id])
    end

    def new
      @card_charge = CardCharge.new
    end

    def edit
      @card_charge = current_company.card_charges.find(params[:id])
    end

    def create
      @card_charge = CardCharge.new(params[:card_charge])

      if @card_charge.save
        redirect_to admin_card_charge_path(@card_charge)
      else
        render action: "new"
      end
    end

    def update
      @card_charge = current_company.card_charges.find(params[:id])

      if @card_charge.update_attributes(params[:card_charge])
        redirect_to admin_card_charge_path(@card_charge)
      else
        render action: "edit"
      end
    end

    def destroy
      @card_charge = current_company.card_charges.find(params[:id])
      @card_charge.destroy

      redirect_to admin_card_charges_url
    end

    protected

    def merge_current_company
      params[:card_charge].merge!(company: current_company)
    end
  end
end

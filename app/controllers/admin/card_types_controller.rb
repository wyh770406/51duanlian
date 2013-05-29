module Admin
  class CardTypesController < Admin::BaseController
    skip_before_filter :check_current_gym
    before_filter :load_gym_groups, only: [:new, :edit]
    before_filter :merge_current_company, only: [:create, :update]
    
    def index
      @card_types = current_company.card_types
    end

    def new
      @card_type = CardType.new
    end

    def edit
      @card_type = current_company.card_types.find(params[:id])
    end

    def create
      @card_type = CardType.new(params[:card_type])

      if @card_type.save
        redirect_to admin_card_types_url
      else
        render action: "new"
      end
    end

    def update
      @card_type = current_company.card_types.find(params[:id])

      if @card_type.update_attributes(params[:card_type])
        redirect_to admin_card_types_url
      else
        render action: "edit"
      end
    end

    def destroy
      @card_type = current_company.card_types.find(params[:id])
      @card_type.destroy

      redirect_to admin_card_types_url
    end

    protected

    def load_gym_groups
      @gym_groups = current_company.gym_groups
    end
 
    def merge_current_company
      params[:card_type].merge!(company: current_company)
    end
  end
end

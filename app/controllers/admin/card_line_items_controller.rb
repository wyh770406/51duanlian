module Admin
  class CardLineItemsController < Admin::BaseController
    def index
      @card_line_items = current_company.card_line_items.without_order.order('created_at DESC').page(params[:page]).per(15)
    end

    def new
      @card = current_gym.cards.find(params[:card_id])
      @card_line_item = @card.card_line_items.build      
    end
 
    def create
      @card = current_gym.cards.find(params[:card_id])
      @card_line_item = CardLineItem.new(params[:card_line_item].merge(card: @card))
 
      if @card_line_item.save
        redirect_to admin_card_path(@card)
      else
        @card_line_item = @card_line_item.dup
        flash[:alert] = t("flash.card_line_items.create.failure")
        render action: "new"
      end
    end
  end
end

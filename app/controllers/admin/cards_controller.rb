module Admin
  class CardsController < Admin::BaseController
    before_filter :merge_current_company, only: [:create, :update]

    def index
      @q = current_gym.cards.search(params[:q])
      @cards = @q.result.page(params[:page]).per(15)
    end

    def show
      @card = current_gym.cards.includes(:card_line_items).find(params[:id])
      @card_line_items = @card.card_line_items.order("updated_at")
      @card_charges = current_gym.card_charges
    end

    def new
      @card = Card.new(:gym_id=>current_gym.id)
    end

    def edit
      @card = current_gym.cards.find(params[:id])
    end

    def create
      @batch_create = params[:batch_create]

      unless @batch_create
        @card = Card.new(params[:card])
        @card.current_gym = current_gym
        if @card.save
          redirect_to admin_card_path(@card)
        else
          render action: "new"
        end
      else
        @cards = Card.batch_create(params[:card])
        redirect_to admin_cards_path, notice: t("flash.cards.create.batch", count: @cards.size)
      end
    end

    def update
      @card = current_gym.cards.find(params[:id])

      params[:card].each do |key, value|
        @card[key] = value
      end
      @card.current_gym = current_gym
      if @card.save
        redirect_to admin_card_path(@card)
      else
        render action: "edit"
      end
    end

    def destroy
      @card = current_gym.cards.find(params[:id])
      @card.destroy

      redirect_to admin_cards_url
    end

    def clear_cards
      current_gym.cards.each do |card|
        card.destroy
      end
      redirect_to admin_cards_url
    end

    def charge
      @card_charge = CardCharge.find(params[:card_charge_id])
      @card = current_gym.cards.find(params[:id])
      @card_order = @card_charge.create_order(current_user, @card, t('card_charge_for', user: @card.username, mobile: @card.mobile), current_gym)

      redirect_to admin_order_path(@card_order)
    end

    protected

    def merge_current_company
      params[:card].merge!(company: current_company)
    end
  end
end

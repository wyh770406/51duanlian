class CardsController < BaseController
  def index
    @cards = current_user.cards
  end

  def show
    @card = current_user.cards.find(params[:id])
    @card_line_items = @card.card_line_items.order("updated_at")
    @card_charges = @card.card_charges
  end

  def new
    @card_type = CardType.find(params[:card_type_id])
    @gym = Gym.find(params[:gym_id])
    @card = @card_type.cards.build(gym: @gym, username: current_user.name, email: current_user.email, mobile: current_user.mobile)
  end

  def create
    @card_type = CardType.find(params[:card][:card_type_id])
    params[:card][:user] = current_user

    @card = Card.sell_to(@card_type, params[:card])
    if @card
      redirect_to card_path(@card)
    else
      redirect_to new_card_path(card_type_id: @card_type, gym_id: params[:card][:gym_id]), alert: t("flash.cards.create.failure")
    end
  end

  def charge
    @card_charge = CardCharge.find(params[:card_charge_id])
    @card = current_user.cards.find(params[:id])
    @card_order = @card_charge.create_order(current_user, @card)

    redirect_to order_path(@card_order)
  end
end

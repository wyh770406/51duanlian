module OrdersHelper
  def order_state_options(state_machine = :state)
    Order.state_machines[state_machine.to_sym].states.inject([[t("all"), '']]) do |options, s|
      if (s.name.to_s != "cart") && Order.respond_to?("human_#{state_machine.to_s}_name")
        options << [Order.send("human_#{state_machine.to_s}_name", s.name), s.name]
      end
      options
    end
  end

  def cards_for(user, gym)
    cards = user.present? ? user.cards : Card
    cards.by_gym(gym).available.map { |card| ["#{card.number}: #{number_to_currency card.balance}", card.id] }
  end

  def cards_typeahead(gym)
    gym.cards.available.map { |c| 
      "#{c.id.to_s} (#{Card.human_attribute_name(:number)}:#{c.number}, #{Card.human_attribute_name(:username)}:#{c.username.to_s}, #{Card.human_attribute_name(:email)}:#{c.email.to_s}, #{Card.human_attribute_name(:mobile)}:#{c.mobile})"
    }.to_s
  end

  def payable_cards(order)
    current_user.cards.by_gym(order.gym).available.payable(order.remained_to_pay(true))
  end
end

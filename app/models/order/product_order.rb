class Order::ProductOrder < Order

  def populate(items_attributes)
    items_attributes.each do |attrs|
      if attrs[:quantity].to_i > 0
        product = self.gym.products.find(attrs[:id])
        line_item = LineItem.find_or_initialize_by_order_id_and_purchasable_type_and_purchasable_id(
          self.id,
          product.class.to_s,
          product.id
        )
        line_item.quantity ||= 0
        line_item.quantity += attrs[:quantity].to_i
        line_item.price = product.price
        line_item.member_price = product.member_price
        line_item.save!
      end
    end
  end

  protected

  def self.initial
    'P'
  end
end

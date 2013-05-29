class AddPriceAndMemberPrice < ActiveRecord::Migration
  def change
    add_column :venues, :price, :decimal, { :precision => 8, :scale => 2 }
    add_column :venues, :member_price, :decimal, { :precision => 8, :scale => 2 }
    Venue.all.each do |v|
      v.update_attributes(price: v.activity.venue_rule.price,
                          member_price: v.activity.venue_rule.member_price)
    end

    add_column :line_items, :member_price, :decimal, { :precision => 8, :scale => 2 }
    LineItem.all.each do |li|
      li.update_attributes(member_price: li.price)
    end

    add_column :orders, :member_total, :decimal, { :precision => 8, :scale => 2 }
    Order.all.each do |o|
      o.update_attributes(member_total: o.total)
    end
  end
end

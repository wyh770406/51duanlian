module CartHelper
  def link_to_cart
    unless controller_name == "carts"
      link = link_to_if current_order.blank? || current_order.empty?, t("cart_is_empty"), edit_admin_cart_path do
        link_to t('items_in_cart', count: current_order.item_count), edit_admin_cart_path
      end
      content_tag(:li, link)
    end
  end
end
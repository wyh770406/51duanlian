jQuery ->
  $('.cart-container').on 'change', '#line_items form #line_item_quantity', (event) =>
    $(event.target).parents('form').find('input.submit').click()

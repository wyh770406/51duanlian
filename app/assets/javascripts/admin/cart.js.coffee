jQuery ->
  $('#line_items form').on 'change', '#line_item_quantity', (event) =>
    $(event.target).parents('form').find('input.submit').click()
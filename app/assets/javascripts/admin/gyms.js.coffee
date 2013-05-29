jQuery ->
  $('ul#gym-image-thumb-list li').hover(
    -> $(this).find('a.delete').show()
    -> $(this).find('a.delete').hide()
  )

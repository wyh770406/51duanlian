jQuery ->
  areas = $('#dynamic_area').html()

  update_areas_options = ->
    city = $('#city_for_dynamic_area :selected').text()
    escaped_city = city.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    areas_in_city = $(areas).filter("optgroup[label=#{escaped_city }]").html()
    areas_in_city = "<option></option>" + areas_in_city
    if areas_in_city
      $('#dynamic_area').html(areas_in_city)
    else
      $('#dynamic_area').empty()

  update_areas_options()

  $('#city_for_dynamic_area').change(update_areas_options)

jQuery ->
  update_venue_rule_fields = ->
    selected_rule = $('#venue_rule_type_of_activity option:selected').val()
    $('#venue_rule_type_of_activity option').each ->
      rule = $(this).val()
      if rule == selected_rule
        $("##{rule}").show()
      else
        $("##{rule}").hide()

  update_venue_rule_fields()
  $('#venue_rule_type_of_activity').change(update_venue_rule_fields)
  $('form').submit =>
    selected_rule = $('#venue_rule_type_of_activity option:selected').val()
    $('#venue_rule_type_of_activity option').each ->
      rule = $(this).val()
      if rule != selected_rule
        $("##{rule}").remove()

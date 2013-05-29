module FormHelper
  def city_select_tag(name, selected = nil, options = {})
    select_tag name, options_for_select(City.all.map { |c| [c.name, c.id] }, selected.try(:id)), options
  end

  def area_select_tag(name, selected = nil, options = {})
    select_tag name, option_groups_from_collection_for_select(City.all, :areas, :name, :id, :name, selected.try(:id)), options
  end

  def refund_to_select_tag(name, cards, selected = nil, options = {})
    select = cards.map { |c| [c.number, c.id] } << [t(:cash), '']
    select_tag name, options_for_select(select, selected.try(:id)), options
  end
end
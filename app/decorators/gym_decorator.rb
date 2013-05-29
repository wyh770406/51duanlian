class GymDecorator < ApplicationDecorator
  decorates :gym

  def phone
    not_none(model.phone)
  end
  
  def open_at
    l_time(model.open_at)
  end

  def close_at
    l_time(model.close_at)
  end

  def venue_types
    model.venue_types.map(&:name).join(', ')
  end

  def description
    not_none(model.description)
  end

  def confirm_button
    if model.confirmed
      if h.can?(:deny, model)
        h.link_to h.deny_admin_gym_path(model), class: 'btn btn-danger', method: :post do
          h.content_tag(:i, nil, class: "icon-remove icon-white") +
          h.t('crud.deny')
        end
      end
    else
      if h.can?(:confirm, model)
        h.link_to h.confirm_admin_gym_path(model), class: 'btn btn-success', method: :post do
          h.content_tag(:i, nil, class: "icon-ok icon-white") +
          h.t('crud.confirm')
        end
      end
    end
  end
end
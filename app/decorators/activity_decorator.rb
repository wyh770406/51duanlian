class ActivityDecorator < ApplicationDecorator
  decorates :activity

  def start_date
    l_date(model.start_date)
  end

  def end_date
    l_date(model.end_date)
  end

  def venue_type
    model.venue_type.name
  end

  def description
    not_none(model.description)
  end

  def active
    if model.active
      h.content_tag(:span, h.t('enabled'), class: "label label-success")
    else
      h.content_tag(:span, h.t('disabled'), class: "label")
    end
  end

  def link_to_edit
    h.link_to_if(model.active, h.t('crud.edit'), '#', class: 'disabled') do
      h.link_to h.t('crud.edit'), h.edit_admin_activity_path(model)
    end
  end

  def button_to_edit
    unless model.active
      h.link_to h.t('crud.edit'), h.edit_admin_activity_path(model), class: "btn btn-primary"
    end
  end

  def link_to_destroy
    h.link_to_if(model.active, h.t('crud.destroy'), '#', class: 'disabled') do
      super
    end
  end

  def button_to_destroy
    unless model.active
      super
    end
  end

  def switch_of_active
    if model.can_switch_active?
      if model.active
        h.link_to h.try_disable_admin_activity_path(model), class: 'btn btn-danger' do
          h.content_tag(:i, nil, class: "icon-remove icon-white") +
          h.t('crud.try_disable')
        end
      else
        h.link_to h.enable_admin_activity_path(model), class: 'btn btn-success', confirm: h.t('notice.enable_confirmation'), method: :post do
          h.content_tag(:i, nil, class: "icon-ok icon-white") +
          h.t('crud.enable')
        end
      end
    end
  end
end
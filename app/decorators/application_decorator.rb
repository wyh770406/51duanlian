class ApplicationDecorator < Draper::Base

  def l_time(time)
    h.l(time, format: :time)
  end

  def l_date(date)
    h.l(date, format: :long)
  end

  def l_datetime(datetime)
    h.l(datetime, format: :long)
  end

  def link_to_show
    h.link_to h.t('crud.show'), [:admin, model]
  end

  def link_to_destroy
    h.link_to h.t('crud.destroy'), [:admin, model], confirm: h.t('crud.destroy_confirmation'), method: :delete
  end

  def button_to_destroy
    h.link_to h.t('crud.destroy'), [:admin, model], confirm: h.t('crud.destroy_confirmation'), method: :delete, class: "btn btn-danger"
  end

  protected

  def handle_none(value)
    if value.present?
      yield
    else
      h.t("none")
    end
  end

  def not_none(value)
    handle_none(value) do
      value
    end
  end
end
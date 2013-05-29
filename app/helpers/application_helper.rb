module ApplicationHelper
  def sign_up_title(role)
    if role == 'leader'
      t('sign_up_as_leader')
    else
      t('sign_up_title')
    end
  end
end

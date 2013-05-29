class RecurrenceRule::DateRule < RecurrenceRule
  belongs_to :date_recurrent, :polymorphic => true

  store_accessor :settings, :start_date, :end_date

  validates :start_date, :end_date, presence: true

  def self.description
    I18n.t('recurrence_rule.date_rule')
  end

  def start_date=(value)
    self.settings[:start_date] = begin
      if value.is_a? Date
        value
      elsif value.is_a? String
        Date.parse(value)
      elsif ((value.is_a? Time) || (value.is_a? DateTime))
        value.to_date
      end
    rescue
      nil
    end
  end

  def end_date=(value)
    self.settings[:end_date] = begin
      if value.is_a? Date
        value
      elsif value.is_a? String
        Date.parse(value)
      elsif ((value.is_a? Time) || (value.is_a? DateTime))
        value.to_date
      end
    rescue
      nil
    end
  end
end

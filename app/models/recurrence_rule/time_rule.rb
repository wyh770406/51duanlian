class RecurrenceRule::TimeRule < RecurrenceRule
  belongs_to :time_recurrent, :polymorphic => true

  store_accessor :settings, :start_time, :end_time, :duration

  validates :start_time, :end_time, :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }

  def self.description
    I18n.t('recurrence_rule.time_rule')
  end

  def start_time=(value)
    self.settings[:start_time] = begin
      if value.is_a? DateTime
        value
      elsif value.is_a? Time
        value.to_datetime
      elsif value.is_a? String
        Time.parse(value).to_datetime
      elsif value.is_a? Date
        value.to_time.to_datetime
      end
    rescue
      nil
    end
  end

  def end_time=(value)
    self.settings[:end_time] = begin
      if value.is_a? DateTime
        value
      elsif value.is_a? Time
        value.to_datetime
      elsif value.is_a? String
        Time.parse(value).to_datetime
      elsif value.is_a? Date
        value.to_time.to_datetime
      end
    rescue
      nil
    end
  end

  def duration=(value)
    self.settings[:duration] = begin
      value.to_i
    rescue
      0
    end
  end
end

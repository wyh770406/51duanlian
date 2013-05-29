class RecurrenceRule::TimeRule::MinutelyRule < RecurrenceRule::TimeRule
  def self.description
    I18n.t('recurrence_rule.time.minutely_rule')
  end

  def schedule(date = nil)
    if date.blank?
      start_time = Time.parse(self.start_time.to_s)
      end_time   = Time.parse(self.end_time.to_s)
    else
      start_time = Time.parse(self.start_time.change(year: date.year, month: date.month, day: date.day).to_s)
      end_time   = Time.parse(self.end_time.change(year: date.year, month: date.month, day: date.day).to_s)
    end
    @schedule = IceCube::Schedule.new(start_time, end_time: end_time)
    @schedule.add_recurrence_rule IceCube::Rule.minutely(self.duration)
    @schedule
  end
end

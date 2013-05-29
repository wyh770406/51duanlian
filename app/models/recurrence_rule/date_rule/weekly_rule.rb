class RecurrenceRule::DateRule::WeeklyRule < RecurrenceRule::DateRule
  # Reorder days for start from Monday.
  DAYS = {
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 0
  }

  store_accessor :settings, :days

  def self.description
    I18n.t('recurrence_rule.date.weekly_rule')
  end

  def schedule
    @schedule = IceCube::Schedule.new(self.start_date.to_time, end_time: self.end_date.to_time)
    @schedule.add_recurrence_rule IceCube::Rule.weekly.day(*day_ids)
    @schedule
  end

  def day_ids
    unless self.days.blank?
      self.days.split(',').map(&:to_i)
    else
      DAYS.values
    end
  end

  def day_ids=(value)
    @day_ids = value
    value = DAYS.values if value.size <= 0
    self.days = value.join(',')
  end

  def day_names
    DAYS.select { |name, i| self.day_ids.include?(i) }.keys.map { |name| I18n.t(name) }
  end
end

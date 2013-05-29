class Activity < ActiveRecord::Base
  DISPLAY = [:both, :front_end, :back_end]
  has_ancestry

  belongs_to :gym
  belongs_to :venue_type
  has_many :venues, dependent: :destroy
  has_one :date_rule, as: :date_recurrent, class_name: 'RecurrenceRule::DateRule', dependent: :destroy,
          conditions: { type: [RecurrenceRule::DateRule, RecurrenceRule::DateRule.subclasses].flatten.map(&:name) }
  accepts_nested_attributes_for :date_rule
  has_one :time_rule, as: :time_recurrent, class_name: 'RecurrenceRule::TimeRule', dependent: :destroy,
          conditions: { type: [RecurrenceRule::TimeRule, RecurrenceRule::TimeRule.subclasses].flatten.map(&:name) }
  accepts_nested_attributes_for :time_rule
  has_one :venue_rule, dependent: :destroy
  accepts_nested_attributes_for :venue_rule

  validates :name, :quantity, :gym, :venue_type, :date_rule, :time_rule, :venue_rule, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  attr_accessible :name, :description, :quantity, :display_on, :gym, :venue_type, :venue_type_id, :date_rule_attributes, :time_rule_attributes, :venue_rule_attributes, :parent_id

  delegate :start_date, :end_date, to: :date_rule

  scope :inactive, lambda { where("active IS NULL OR active IS FALSE") }

  def can_switch_active?
    is_root?
  end

  def enable
    self.transaction do
      unless self.active
        activities_date_map.each do |date, activities|
          activities.each do |activity|
            times = activity.time_rule.schedule(date).all_occurrences
            (0...times.size).each do |i|
              if times[i] && times[i + 1]
                self.venues << activity.venue_rule.generate(
                  start_at: times[i],
                  stop_at: times[i + 1],
                  quantity: activity.quantity,
                )
              else
                break
              end
            end
          end
        end

        self.descendants.each do |a|
          a.active = true
          a.save
        end
        self.active = true
        self.save

        true
      else
        false
      end
    end
  end

  def disable
    if self.active
      self.venues.clear

      self.descendants.each do |a|
        a.active = false
        a.save
      end
      self.active = false
      self.save

      true
    else
      false
    end
  end

  def activities_date_map
    result_map = Hash.new { |h,k| h[k] = [] }

    self.date_rule.schedule.each_occurrence do |d|
      result_map[d.to_date] = [self]
    end

    self.children.each do |child|
      child.activities_date_map.each do |date, activities|
        if result_map[date].blank? || result_map[date] == [self]
          result_map[date] = activities
        else
          result_map[date] += activities
        end
      end
    end

    result_map
  end

  def published_to
    venue = venues.active.order(:stop_at).last.try(:stop_at)
  end
end

class RecurrenceRule < ActiveRecord::Base
  # Building the right class with STI in Rails
  # Taken from http://coderrr.wordpress.com/2008/04/22/building-the-right-class-with-sti-in-rails/
  class << self
    def new_with_cast(*a, &b)
      if (h = a.first).is_a? Hash and (type = h[:type] || h['type']) and (klass = type.constantize) != self
        raise "wtF hax!!"  unless klass < self  # klass should be a descendant of us
        return klass.new(*a, &b)
      end

      new_without_cast(*a, &b)
    end
    alias_method_chain :new, :cast
  end

  store :settings

  def self.description
    'Base Recurrence Rule'
  end

  def schedule
    IceCube::Schedule.new
  end
end

Dir["#{File.dirname(__FILE__)}/#{File.basename(__FILE__, '.*')}/**/*.rb"].each { |f| require_dependency f }

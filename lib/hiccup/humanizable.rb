require "hiccup/convenience"
require "hiccup/core_ext/fixnum"


module Hiccup
  module Humanizable
    include Convenience
    
    
    
    def humanize
      case kind
      when :never;      ""
      when :weekly;     weekly_humanize
      when :monthly;    monthly_humanize
      when :annually;   yearly_humanize
      else;             "Invalid"
      end
    end
    
    
    
  private
    
    
    
    def weekly_humanize
      weekdays = pattern.map(&:humanize).to_sentence
      if skip == 1 || pattern.length == 1
        sentence("Every", ordinal, weekdays)
      else
        sentence(weekdays, "of every", ordinal, "week")
      end
    end
    
    def monthly_humanize
      monthly_occurrences = pattern.map(&method(:monthly_occurrence_to_s)).to_sentence
      sentence("The", monthly_occurrences, "of every", ordinal, "month")
    end
    
    def yearly_humanize
      sentence("Every", ordinal, "year on", self.start_date.strftime('%b %d'))
    end
    
    
    
    def monthly_occurrence_to_s(monthly_occurrence)
      if monthly_occurrence.is_a?(Array)
        _skip, weekday = monthly_occurrence
        ordinal = _skip.human_ordinalize
        sentence(ordinal, weekday.humanize)
      else
        monthly_occurrence.ordinalize
      end
    end
    
    def ordinal
      skip && skip.human_ordinalize(1 => nil, 2 => "other")
    end
    
    def sentence(*array)
      array.compact.join(" ")
    end
    
    
    
  end
end
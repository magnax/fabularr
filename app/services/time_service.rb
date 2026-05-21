# frozen_string_literal: true

module TimeService
  MINUTE = 300
  MINUTES_IN_HOUR = 24
  HOURS_IN_DAY = 12

  # assumptions: 1 year is 20 days, one day consists of 12 hours, each hour has 12 minutes
  # so the basic "tick" (game's minute) is real time 5 minutes - at least for now
  #
  # "base_speed" in projects etc. refers to real time seconds

  def self.display_time(base_speed)
    hours = (base_speed.to_f / MINUTE / MINUTES_IN_HOUR).round(0)
    hours = 1 if hours < 1

    return display_hours(hours) if hours < 12

    display_days(hours)
  end

  def self.display_hours(hours)
    key = if hours == 1
            'time.1_hour'
          elsif hours < 5
            'time.2_hours'
          else
            'time.5_hours'
          end

    "#{hours} #{I18n.t(key)}"
  end

  def self.display_days(hours)
    # days are displayed in fractions of 0.25
    full_days = hours / 12
    rem_hours = hours - (full_days * 12)
    days = full_days + (rem_hours / 12.0 * 4).ceil * 0.25

    key = if days == 1
            'time.1_day'
          elsif days.to_s.gsub('.0', '') == days.to_s
            'time.fraction_day'
          else
            'time.2_days'
          end

    "#{days.to_s.gsub('.0', '')} #{I18n.t(key)}"
  end
end

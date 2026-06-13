# frozen_string_literal: true

class GameTime < ApplicationRecord
  DAY = 86_400
  HOUR = DAY / 12
  MINUTE = HOUR / 12

  def datetime
    diff = updated_at.to_i - created_at.to_i
    day = diff / DAY
    seconds = diff - (day * 86_400)
    hours = seconds / HOUR
    minute = (seconds - (hours * HOUR)) / MINUTE

    {
      day: day,
      hour: hours,
      minute: minute
    }
  end
end

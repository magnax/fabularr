# frozen_string_literal: true

# == Schema Information
#
# Table name: game_times
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GameTime < ApplicationRecord
  DAY = 86_400
  HOUR = DAY / 12
  MINUTE = HOUR / 12
  DAYS_IN_YEAR = 20

  def datetime(from_date = nil)
    end_date = from_date || updated_at
    diff = end_date.to_i - created_at.to_i
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

  def days(end_date = nil)
    diff = (end_date || updated_at).to_i - created_at.to_i

    diff / DAY
  end
end

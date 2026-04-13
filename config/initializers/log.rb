# frozen_string_literal: true

module Log
  def self.say(msg)
    return if Rails.env.test?

    puts msg
  end
end

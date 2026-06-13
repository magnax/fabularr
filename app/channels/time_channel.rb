# frozen_string_literal: true

class TimeChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'time_channel'
  end

  def unsubscribed; end
end

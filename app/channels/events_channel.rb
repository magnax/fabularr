# frozen_string_literal: true

class EventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "events_#{params[:location_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

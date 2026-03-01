# frozen_string_literal: true

class LocationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "location_#{params[:location_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

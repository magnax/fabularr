# frozen_string_literal: true

class CharacterChannel < ApplicationCable::Channel
  def subscribed
    stream_from "char_#{params[:character_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

# frozen_string_literal: true

module Events
  class BroadcastService < ApplicationService
    def initialize(char_id, event_id)
      @char_id = char_id
      @event_id = event_id
    end

    def call
      ActionCable.server.broadcast(
        "char_#{@char_id}",
        { type: 'event', event_id: @event_id }
      )
    end
  end
end

# frozen_string_literal: true

module Events
  module CreateService
    def self.call!(params)
      event = Event.create!(params)

      ActionCable.server.broadcast("events_#{params[:location_id]}", { id: event.id })
    end
  end
end

# frozen_string_literal: true

module Events
  module CreateService
    def self.call!(params)
      event = Event.create!(params)

      ActionCable.server.broadcast(
        "location_#{params[:location_id]}",
        {
          type: 'event', event_id: event.id
        }
      )
    end
  end
end

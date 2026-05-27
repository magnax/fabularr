# frozen_string_literal: true

module Events
  class CreateEventForAllService < ApplicationService
    def initialize(characters, body, except: nil)
      @characters = characters
      @body = body
      @except = except
    end

    def call
      @characters.each do |ch|
        next if ch == @except

        Event.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: @body
        )

        ActionCable.server.broadcast("char_#{ch.id}", { type: 'event', body: @body })
      end
    end
  end
end

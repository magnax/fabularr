# frozen_string_literal: true

module Events
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      hearable_characters.each do |char|
        event = Event.create!(
          body: body(char),
          character: event_character,
          receiver_character: char
        )

        ActionCable.server.broadcast(
          "char_#{char.id}",
          {
            type: 'event', event_id: event.id
          }
        )
      end
    end

    private

    def body(character)
      if receiver_character.present?
        if character == @character
          I18n.t('events.character.talking.to_other', char_name: receiver_character.char_id, body: @params[:body])
        else
          I18n.t('events.character.talking.to_me', char_name: @character.char_id, body: @params[:body])
        end
      elsif character == @character
        I18n.t('events.character.talking.me', body: @params[:body])
      else
        I18n.t('events.character.talking.other', char_name: @character.char_id, body: @params[:body])
      end
    end

    def event_character
      @event_character ||= @params[:receiver_character_id] ? @character : nil
    end

    def hearable_characters
      @hearable_characters = begin
        return [@character, receiver_character] if receiver_character.present?

        location.present? ? location.hearable_characters : []
      end
    end

    def location
      @location ||= @character.location
    end

    def receiver_character
      @receiver_character ||= begin
        return unless @params[:receiver_character_id]

        Character.find_by(id: @params[:receiver_character_id])
      end
    end
  end
end

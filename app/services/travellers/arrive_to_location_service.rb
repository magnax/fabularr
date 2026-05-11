# frozen_string_literal: true

module Travellers
  class ArriveToLocationService < ApplicationService
    def initialize(traveller, location = nil)
      @traveller = traveller
      @location = location
    end

    def call
      create_location_events!
      update_subject_location!

      @traveller.update!(status: false)

      create_traveller_events!
    end

    private

    def update_subject_location!
      params = if character?
                 { location: destination_location }
               else
                 { parent_location: destination_location }
               end

      subject.update!(params.merge(coords: nil))
    end

    def create_traveller_events!
      travelling_characters.each do |char|
        Event.create!(
          receiver_character: char,
          body: I18n.t(
            'events.travel.arrive', location_link: destination_location.loc_id
          )
        )
      end
    end

    def create_location_events!
      destination_location.visible_characters.each do |char|
        Event.create!(
          receiver_character: char,
          body: I18n.t(
            'events.travel.arrive_other',
            traveller_link: subject_link,
            location_link: @traveller.start_location.loc_id
          )
        )
      end
    end

    def subject_link
      return subject.char_id if character?

      subject.loc_id
    end

    def character?
      subject.is_a?(Character)
    end

    def travelling_characters
      @travelling_characters ||= begin
        return [subject] if subject.is_a?(Character)

        subject.characters
      end
    end

    def subject
      @subject ||= @traveller.subject
    end

    def destination_location
      @destination_location ||= @location || @traveller.destination_location
    end
  end
end

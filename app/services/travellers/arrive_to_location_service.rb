# frozen_string_literal: true

module Travellers
  class ArriveToLocationService < ApplicationService
    def initialize(traveller)
      @traveller = traveller
    end

    def call
      update_subject_location!

      @traveller.update!(status: false)

      create_events!
    end

    private

    def update_subject_location!
      params = if subject.is_a?(Character)
                 { location: @traveller.destination_location }
               else
                 { parent_location: @traveller.destination_location }
               end

      subject.update!(params.merge(coords: nil))
    end

    def create_events!
      create_traveller_event!
    end

    def create_traveller_event!
      Event.create!(
        receiver_character: travelling_character,
        body: I18n.t(
          'events.travel.arrive', location_link: @traveller.destination_location.loc_id
        )
      )
    end

    def travelling_character
      @travelling_character ||= begin
        return subject if subject.is_a?(Character)

        # TODO: temporary solution, there could be more characters
        subject.characters.first
      end
    end

    def subject
      @subject ||= @traveller.subject
    end
  end
end

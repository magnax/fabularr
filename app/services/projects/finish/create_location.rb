# frozen_string_literal: true

module Projects
  class Finish::CreateLocation < ApplicationService
    include Projects::UpdateWorkers
    include Projects::EndEvents

    def initialize(project)
      @project = project
    end

    def call
      location = Locations::CreateService.call(position)

      update_travellers!(location)
      project_description.update!(subject: location)
      @project.update!(location: location)

      update_workers!

      notify_starting_character
    end

    private

    def body
      I18n.t('events.projects.create_location_ended', location_info: location_info)
    end

    def location_info
      @location_info ||= I18n.t(
        "locations.#{location_description.subject.location_type.key}"
      )
    end

    def location_description
      @location_description ||= @project.project_descriptions.location.first
    end

    def position
      project_description.metadata['coords']
    end

    def update_travellers!(location)
      travellers.each do |traveller|
        character = traveller.subject
        character.update!(location: location)
        traveller.destroy
        next if character == starting_character

        create_event_and_broadcast!(character)
      end
    end

    def create_event_and_broadcast!(character)
      event = Event.create!(
        receiver_character: character,
        body: I18n.t('events.locations.arrive_created')
      )
      ActionCable.server.broadcast("character_#{character.id}", { type: 'event', event_id: event.id })
    end

    def travellers
      @travellers ||=
        Traveller.joins('inner join characters ch on ch.id = travellers.subject_id')
                 .where(
                   "length(
                    lseg(ch.coords::point, point(#{position['x']}, #{position['y']}))
                  ) < ?", Character::MIN_HEARABLE_DISTANCE
                 )
    end

    def starting_character
      @starting_character ||= @project.starting_character
    end

    def project_description
      @project_description ||= @project.project_descriptions.location&.first
    end
  end
end

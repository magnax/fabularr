# frozen_string_literal: true

module ProjectTypes
  class CreateLocation < ApplicationService
    def initialize(project_id)
      @project_id = project_id
    end

    def call
      location = Location.create!(location_type: location_type,
                                  location_class: LocationClass.find_by(key: 'town'),
                                  coords: starting_character.coords)
      update_travellers!(location)
      pd = project.project_descriptions.where(
        description_type: ProjectDescription::LOCATION
      ).first_or_create
      pd.update!(
        subject: location
      )
    end

    private

    def location_type
      @location_type ||= Maps.location_type(*position)
    end

    def position
      [starting_character.x, starting_character.y]
    end

    def update_travellers!(location)
      travellers.each do |traveller|
        character = traveller.subject
        character.update!(location: location)
        character.traveller.destroy
        next if character == starting_character

        create_event_and_broadcast!(character, location)
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
                    lseg(ch.coords::point, point(#{starting_character.x}, #{starting_character.y}))
                  ) < ?", Character::MIN_HEARABLE_DISTANCE
                 )
    end

    def starting_character
      @starting_character ||= project.starting_character
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end

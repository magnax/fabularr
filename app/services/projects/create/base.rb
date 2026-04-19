# frozen_string_literal: true

module Projects
  class Create::Base < ApplicationService
    attr_reader :project_type

    def initialize(character, project_type, params)
      @character = character
      @project_type = project_type
      @params = params
    end

    def call
      @project = create_project!

      create_creator_event!
      create_others_events!
    end

    private

    def create_project!
      Project.create!(project_attributes)
    end

    def project_base_attributes
      {
        starting_character: @character,
        location: location,
        project_type_id: project_type.id
      }
    end

    def create_creator_event!
      Event.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me', info: project_info)
      )
    end

    def create_others_events!
      body = I18n.t(
        'events.projects.starting_other',
        character_link: @character.char_id
      )
      Events::CreateEventForAllService.call(location.characters, body, except: @character)
    end

    def location
      @location ||= @character.location
    end
  end
end

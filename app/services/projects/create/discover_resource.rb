# frozen_string_literal: true

module Projects
  class Create::DiscoverResource < ApplicationService
    attr_reader :project_type

    def initialize(character, project_type, _params)
      @character = character
      @project_type = project_type
    end

    def call
      @project = create_project!

      create_creator_event!
      body = I18n.t(
        'events.projects.starting_other',
        character_link: @character.char_id
      )
      Events::CreateEventForAllService.call(location, body, except: @character)
    end

    private

    def create_project!
      Project.create!(project_base_attributes)
    end

    def project_base_attributes
      {
        starting_character: @character,
        location: location,
        project_type_id: project_type.id,
        duration: project_type.base_speed,
        amount: nil,
        ready: true
      }
    end

    def create_creator_event!
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me', info: project_info)
      )
    end

    def project_info
      I18n.t("project_types.#{project_type.key}")
    end

    def location
      @location ||= @character.location
    end
  end
end

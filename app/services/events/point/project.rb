# frozen_string_literal: true

module Events
  class Point::Project < ApplicationService
    def initialize(character, subject)
      @character = character
      @subject = subject
    end

    def call
      raise InvalidPointObjectError unless visible_project?

      Event.create!(
        body: I18n.t('events.point.point_project_me', project_info: project_info),
        receiver_character_id: @character.id
      )

      create_location_events!
    end

    private

    def visible_project?
      project.location == @character.location
    end

    def create_location_events!
      Events::CreateEventForAllService.call(@character.location.visible_characters,
                                            body, except: @character)
    end

    def body
      I18n.t(
        'events.point.point_project_other',
        project_info: project_info,
        character_link: @character.char_id
      )
    end

    def project_info
      project.name(@character, short: true).downcase
    end

    def project
      @project ||= @subject
    end
  end
end

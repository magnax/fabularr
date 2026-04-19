# frozen_string_literal: true

module Projects
  class Create::CreateLocation < Projects::Create::Base
    private

    def project_attributes
      project_base_attributes.merge(
        {
          duration: project_type.base_speed,
          amount: nil,
          ready: true
        }
      )
    end

    def create_others_events!
      body = I18n.t(
        'events.projects.create_location',
        character_link: @character.char_id
      )
      Events::CreateEventForAllService.call(visible_characters, body, except: @character)
    end

    def project_info
      I18n.t("project_types.#{project_type.key}")
    end

    def visible_characters
      []
    end
  end
end

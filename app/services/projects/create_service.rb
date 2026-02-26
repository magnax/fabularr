module Projects
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      Project.create!(starting_character: @character, location: location, project_type_id: @params[:project_type_id])

      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me')
      )
      body = I18n.t(
        'events.projects.starting_other',
        character_link: "<!--CHARID:#{@character.id}-->"
      )
      Events::CreateEventForAllService.call(location, body, except: @character)
    end

    private

    def location
      @location ||= Location.find_by(id: @params[:location_id])
    end
  end
end

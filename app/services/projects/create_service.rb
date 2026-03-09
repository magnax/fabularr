# frozen_string_literal: true

module Projects
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      Project.create!(
        starting_character: @character,
        location: location,
        project_type_id: project_type.id,
        duration: duration,
        amount: amount
      )

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
      @location ||= @character.location
    end

    def duration
      return project_type.base_speed if project_type.fixed?

      @params[:amount] * project_type.base_speed
    end

    def amount
      @params[:amount]
    end

    def project_type
      @project_type ||= ProjectType.find_by(id: @params[:project_type_id])
    end
  end
end

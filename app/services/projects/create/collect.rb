# frozen_string_literal: true

module Projects
  class Create::Collect < ApplicationService
    attr_reader :project_type

    def initialize(character, project_type, params)
      @character = character
      @project_type = project_type
      @params = params
    end

    def call
      @project = create_project!
      create_project_descriptions!

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
        duration: duration,
        amount: amount,
        ready: true
      }
    end

    def create_project_descriptions!
      @project.project_descriptions.create!(
        description_type: ProjectDescription::RESOURCE_OUT,
        subject: resource,
        amount: 0,
        amount_needed: amount,
        unit: resource.unit
      )
    end

    def create_creator_event!
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.projects.starting_me', info: project_info)
      )
    end

    def project_info
      "#{type_name} #{resource_name}"
    end

    def type_name
      I18n.t("project_types.#{project_type.key}")
    end

    def resource_name
      I18n.t("resources.#{resource.key}")
    end

    def location
      @location ||= @character.location
    end

    def duration
      amount * project_type.base_speed
    end

    def amount
      @params[:amount].to_i
    end

    def resource
      @resource ||= location_resource.resource
    end

    def location_resource
      @location_resource ||= LocationResource.find_by(id: @params[:location_resource_id])
    end
  end
end

# frozen_string_literal: true

module Projects
  class CreateService < ApplicationService
    TYPE_CLASSES = {
      'build' => 'Create::Build',
      'collect' => 'Create::Collect',
      'discover_resource' => 'Create::DiscoverResource'
    }.freeze

    def initialize(character, params)
      @character = character
      @project_type_id = params[:project_type_id]
      @params = params.except(:project_type_id)
    end

    def call
      raise InvalidProjectTypeError if project_type.blank?

      service_class.call(@character, project_type, @params)
    end

    private

    def service_class
      "Projects::#{TYPE_CLASSES[project_type.key]}".constantize
    rescue NameError
      raise NotImplementedError
    end

    def project_type
      @project_type ||= ProjectType.find_by(id: @project_type_id)
    end
  end
end

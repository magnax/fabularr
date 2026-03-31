# frozen_string_literal: true

module Projects
  class FilterMissingResourceService < ApplicationService
    def initialize(character, resource)
      @character = character
      @resource = resource
    end

    def call
      filtered_projects.map do |p|
        amount = p.amount_needed - p.amount.to_f
        name = "#{p.project.name(@character)} (#{amount})"
        [name, p.project_id]
      end
    end

    private

    def filtered_projects
      @filtered_projects ||=
        ProjectDescription
        .resource_in
        .joins(:project)
        .includes(:project)
        .where('project_descriptions.amount < project_descriptions.amount_needed')
        .where(subject_id: @resource.id)
        .where(project: { location_id: @character.location_id })
        .select(
          'project_descriptions.amount,
           project_descriptions.amount_needed,
           project_descriptions.project_id,
           project.id'
        )
    end
  end
end

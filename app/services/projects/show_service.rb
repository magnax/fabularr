# frozen_string_literal: true

module Projects
  class ShowService < ApplicationService
    def initialize(character, project_id)
      @character = character
      @project_id = project_id
    end

    def call
      {
        amount: project.amount,
        items_used: items_used,
        name: project.name(@character, short: true),
        participants: participants,
        problems: problems,
        project_id: project.id,
        progress: project.progress(1),
        repeats: repeats,
        resources_used: resources_used,
        run_type: 'hand', # TODO: will add automatic/semi-automattic types later
        start_day: start_day,
        starting_character_id: project.starting_character.id,
        starting_character_name: project.starting_character.name_for(@character),
        time: time_needed
      }
    end

    private

    def start_day
      TimeService.short_datetime(GameTime.last.datetime(project.created_at))
    end

    def participants
      project.workers.active.map do |worker|
        {
          id: worker.character_id,
          name: worker.character.name_for(@character),
          skill: character_skill(worker.character)
        }
      end
    end

    def character_skill(character)
      Skill::MAP_LEVELS[
        character.character_skills.find_by(skill_id: project.skill).level.to_i
      ]
    end

    def repeats
      return if repeat_description.blank?

      repeat_description.amount.to_i
    end

    def repeat_description
      @repeat_description ||= project.project_descriptions.repeat.first
    end

    def problems
      p = []

      p << I18n.t('views.projects.show.no_resources') unless all_resources?
      p << I18n.t('views.projects.show.no_items') unless all_items?
    end

    def all_resources?
      resources_used.pluck(:to_add).all?(&:zero?)
    end

    def all_items?
      items_used.pluck(:to_add).all?(&:zero?)
    end

    def items_used
      item_descriptions.map do |description|
        {
          key: I18n.tn("items.#{description.subject.key}"),
          needed: description.amount_needed.to_i,
          to_add: (description.amount_needed - description.amount).to_i
        }
      end
    end

    def resources_used
      resource_descriptions.map do |description|
        {
          key: I18n.tn("resources.#{description.subject.key}"),
          needed: description.amount_needed.to_i,
          to_add: (description.amount_needed - description.amount).to_i
        }
      end
    end

    def resource_descriptions
      @resource_descriptions ||= project.project_descriptions.resource_in
    end

    def item_descriptions
      @item_descriptions ||= project.project_descriptions.item_in
    end

    def time_needed
      @time_needed ||= TimeService.display_time(project.duration)
    end

    def project
      @project ||= Project.find_by(id: @project_id)
    end
  end
end

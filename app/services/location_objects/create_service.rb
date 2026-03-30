# frozen_string_literal: true

module LocationObjects
  class CreateService < ApplicationService
    class InvalidParamsError < StandardError; end

    include Events::BodyHelper

    attr_reader :character

    def initialize(character, params)
      @character = character
      @params = params
      @amount = calculated_amount
    end

    def call
      raise InvalidParamsError if inventory_object.blank?

      update_inventory_and_location!
      update_running_project!

      create_events!
    end

    private

    def update_inventory_and_location!
      if location_object.subject.is_a?(Resource)
        location_object.update!(
          amount: location_object.amount + @amount
        )
      end
      update_inventory_object!
    end

    def update_inventory_object!
      if should_destroy_inventory_object?
        inventory_object.destroy
      else
        inventory_object.update!(amount: inventory_object.amount - @amount)
      end
    end

    def should_destroy_inventory_object?
      inventory_object.subject.is_a?(Item) || (inventory_object.amount - @amount).zero?
    end

    def update_running_project!
      return unless current_worker

      if Recipes::CheckToolRequirementsService.call(@character, project)
        return unless dropped_best_tool?

        create_new_worker!
      else
        current_worker.update(left_at: DateTime.current)
      end
    end

    def dropped_best_tool?
      return unless inventory_object.subject.is_a?(Item)
      return unless dropped_optional_tool?

      best_tool.nil? ||
        best_tool == dropped_item_key ||
        optional_tools[dropped_item_key] > optional_tools[best_tool]
    end

    def dropped_optional_tool?
      dropped_item_key.in?(optional_tools.keys)
    end

    def dropped_item_key
      @dropped_item_key ||= inventory_object.subject.item_type.key
    end

    def optional_tools
      @optional_tools ||= Projects::OptionalTools.call(project)
    end

    def create_new_worker!
      current_worker.update(left_at: DateTime.current)
      Worker.create!(
        character: @character, project: project, speed: optional_tools[best_tool] || 1
      )
    end

    def best_tool
      @best_tool ||= Recipes::BestOptionalTool.call(@character, project.recipe)
    end

    def project
      @project ||= current_worker.project
    end

    def current_worker
      @current_worker ||= @character.workers.active.first
    end

    def calculated_amount
      @calculated_amount ||= begin
        return if @params[:amount].blank?

        if @params[:amount].to_f > inventory_object.amount
          inventory_object.amount
        else
          @params[:amount].to_f
        end
      end
    end

    def location_object
      @location_object ||= @character.location.location_objects
                                     .where(subject: subject)
                                     .first_or_create(amount: 0)
    end

    def create_events!
      create_character_event!
      create_other_characters_events!
    end

    def create_character_event!
      Event.create!(
        body: send("drop_#{subject.class.to_s.downcase}_body"),
        location: @character.location,
        receiver_character: @character
      )
    end

    def create_other_characters_events!
      @character.location.visible_characters.each do |char|
        next if char == @character

        Event.create!(
          body: send("drop_#{subject.class.to_s.downcase}_others_body"),
          location: @character.location,
          character: nil,
          receiver_character: char
        )
      end
    end

    def subject
      @subject ||= inventory_object.subject
    end

    def inventory_object
      @inventory_object ||=
        if @params[:inventory_object_id]
          @character.inventory_objects.find_by(id: @params[:inventory_object_id])
        else
          @character.inventory_objects
                    .resource
                    .find_by(subject_id: @params[:subject_id])
        end
    end
  end
end

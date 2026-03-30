# frozen_string_literal: true

module InventoryObjects
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
      raise InvalidParamsError if location_object.blank? && @params[:amount].blank?

      update_inventory_and_location!
      update_running_project!

      create_events!
    end

    private

    def update_inventory_and_location!
      if resource?
        inventory_object.update!(amount: inventory_object.amount + @amount)
      else
        inventory_object
      end
      update_location_object!
    end

    def update_running_project!
      return unless current_worker
      return unless inventory_object_better?

      current_worker.update!(left_at: DateTime.current)
      @character.workers.create!(
        project: current_worker.project, speed: inventory_object_speed
      )
      Event.create!(
        body: 'Your project speed will now increase',
        location: @character.location,
        receiver_character: @character
      )
    end

    def project
      @project ||= current_worker.project
    end

    def current_worker
      @current_worker ||= @character.workers.active.first
    end

    def inventory_object_better?
      true
    end

    def inventory_object_speed
      optional_tools[inventory_object.subject.item_type.key]
    end

    def optional_tools
      @optional_tools ||= Projects::OptionalTools.call(current_worker.project)
    end

    def resource?
      @resource ||= subject.is_a?(Resource)
    end

    def update_location_object!
      if should_destroy_location?
        location_object.destroy
      else
        location_object.update!(amount: location_object.amount - @amount)
      end
    end

    def should_destroy_location?
      item? || (location_object.amount - @amount).zero?
    end

    def item?
      @item ||= subject.is_a?(Item)
    end

    def create_events!
      create_character_event!
      create_other_characters_events!
    end

    def create_character_event!
      Event.create!(
        body: send("take_#{subject.class.to_s.downcase}_body"),
        location: @character.location,
        receiver_character: @character
      )
    end

    def create_other_characters_events!
      @character.location.visible_characters.each do |char|
        next if char == @character

        Event.create!(
          # take_resource_others_body take_item_others_body
          body: send("take_#{subject.class.to_s.downcase}_others_body"),
          location: @character.location,
          character: nil,
          receiver_character: char
        )
      end
    end

    def calculated_amount
      @calculated_amount ||= begin
        return if @params[:amount].blank?
        return char_max_amount if location_max_amount > char_max_amount

        location_max_amount
      end
    end

    def location_max_amount
      @location_max_amount ||= if @params[:amount].to_f > location_object.amount
                                 location_object.amount
                               else
                                 @params[:amount].to_f
                               end
    end

    def char_max_amount
      Character::MAX_CAPACITY - @character.carrying_weight
    end

    def location_object
      @location_object ||= item_location_object || resource_location_object
    end

    def item_location_object
      @item_location_object ||= location.location_objects.item.find_by(id: @params[:location_object_id])
    end

    def resource_location_object
      @resource_location_object ||= location.location_objects
                                            .resource
                                            .find_by(subject_id: @params[:subject_id])
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects
                                      .where(subject: subject)
                                      .first_or_create(amount: 0)
    end

    def subject
      @subject ||= location_object.subject
    end

    def location
      @location ||= @character.location
    end
  end
end

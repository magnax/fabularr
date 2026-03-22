# frozen_string_literal: true

module InventoryObjects
  class CreateService < ApplicationService
    class InvalidParamsError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
      @amount = calculated_amount
    end

    def call
      raise InvalidParamsError if @params[:amount].blank? || location_object.blank?

      update_inventory_and_location!

      create_events!
    end

    private

    def update_inventory_and_location!
      inventory_object.update!(amount: inventory_object.amount + @amount)
      update_location_object!
    end

    def update_location_object!
      if should_destroy_location?
        location_object.destroy
      else
        location_object.update!(amount: location_object.amount - @amount)
      end
    end

    def should_destroy_location?
      (location_object.amount - @amount).zero?
    end

    def create_events!
      create_character_event!
      create_other_characters_events!
    end

    def create_character_event!
      Event.create!(
        body: I18n.t(
          'events.take_resource',
          res: I18n.td("resources.#{subject.key}"),
          amount: @amount.to_i,
          unit: I18n.td(location_object.unit)
        ),
        location: @character.location,
        receiver_character: @character
      )
    end

    def create_other_characters_events!
      @character.location.visible_characters.each do |char|
        next if char == @character

        Event.create!(
          body: I18n.t(
            'events.take_resource_others',
            character_link: @character.char_id,
            res: I18n.td("resources.#{subject.key}")
          ),
          location: @character.location,
          character: @character,
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
      @location_object ||= @character.location.location_objects
                                     .resource
                                     .find_by(subject_id: @params[:subject_id])
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects
                                      .where(subject: subject)
                                      .first_or_create(amount: 0)
    end

    def subject
      subject_class.find_by(id: @params[:subject_id])
    end

    def subject_class
      @subject_class ||= @params[:subject_type].constantize
    end
  end
end

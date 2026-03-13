# frozen_string_literal: true

module LocationObjects
  class CreateService < ApplicationService
    class InvalidParamsError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidParamsError if inventory_object.blank?

      update_inventory_and_location!

      create_events!
    end

    private

    def update_inventory_and_location!
      location_object.update!(amount: location_object.amount + amount)
      update_inventory_object!
    end

    def update_inventory_object!
      if should_destroy_inventory_object?
        inventory_object.destroy
      else
        inventory_object.update!(amount: inventory_object.amount - amount)
      end
    end

    def should_destroy_inventory_object?
      (inventory_object.amount - amount).zero?
    end

    def amount
      if @params[:amount].to_f > inventory_object.amount
        inventory_object.amount
      else
        @params[:amount].to_f
      end
    end

    def inventory_object
      @inventory_object ||= @character.inventory_objects
                                      .resource
                                      .find_by(subject_id: @params[:subject_id])
    end

    def location_object
      @location_object ||= @character.location.location_objects
                                     .where(subject: subject)
                                     .first_or_create(amount: 0)
    end

    def create_events!
      Event.create!(
        body: 'Res. dropped',
        location: @character.location,
        receiver_character: @character
      )
    end

    def subject
      subject_class.find_by(id: @params[:subject_id])
    end

    def subject_class
      @subject_class ||= @params[:subject_type].constantize
    end
  end
end

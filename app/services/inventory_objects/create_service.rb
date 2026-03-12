module InventoryObjects
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      @character.inventory_objects.create!(
        subject: subject,
        amount: @params[:amount]
      )

      Event.create!(
        body: 'Res. taken',
        location: @character.location,
        receiver_character: @character
      )
    end

    private

    def subject
      subject_class.find_by(id: @params[:subject_id])
    end

    def subject_class
      @subject_class ||= @params[:subject_type].constantize
    end
  end
end

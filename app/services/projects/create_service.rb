module Projects
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      Project.create!(starting_character: @character, location: location)
    end

    private

    def location
      @location ||= Location.find_by(id: @params[:location_id])
    end
  end
end

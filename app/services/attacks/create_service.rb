# frozen_string_literal: true

module Attacks
  class CreateService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      service_name.call(@character, @params)
    end

    private

    def service_name
      "Attacks::#{@params[:target_type].camelize}".constantize
    end
  end
end

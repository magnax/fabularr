# frozen_string_literal: true

module Travellers
  class StartService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      Traveller.create!(subject: @character, direction: @params[:direction])
    end
  end
end

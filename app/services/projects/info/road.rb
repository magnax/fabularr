# frozen_string_literal: true

module Projects
  class Info::Road < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      {}
    end
  end
end

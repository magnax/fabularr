# frozen_string_literal: true

module Projects
  class ProjectInfoService < ApplicationService
    class NotImplementedError < StandardError; end

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      class_name.call(@character, @params)
    end

    private

    def class_name
      "Projects::Info::#{@params[:type].titleize}".constantize
    rescue NameError
      raise NotImplementedError
    end
  end
end

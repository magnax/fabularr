# frozen_string_literal: true

module Events
  class PointService < ApplicationService
    SUBJECTS = %w[character project road].freeze

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      raise InvalidPointObjectError unless valid_subject?

      "Events::Point::#{subject_type}".constantize.call(@character, subject)
    end

    private

    def valid_subject?
      @params[:type].downcase.in?(SUBJECTS) && subject.present?
    end

    def subject_type
      @subject_type ||= subject.class
    end

    def subject
      @subject ||= @params[:type].camelize.constantize.find_by(id: @params[:id])
    end
  end
end

# frozen_string_literal: true

module Notes
  class UpdateService < ApplicationService
    include ActionView::Helpers::SanitizeHelper

    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      note.update!(**update_attrs)
    end

    private

    def update_attrs
      {
        title: sanitize_title,
        body: sanitize_body
      }
    end

    def sanitize_title
      sanitize(@params[:title], tags: [])
    end

    def sanitize_body
      sanitize(@params[:body], tags: %w[b i strong], scrubber: scrubber)
    end

    def scrubber
      Loofah::Scrubber.new do |node|
        node.remove if node.name == 'script'
      end
    end

    def note
      @note ||= @character.inventory_objects.note
                          .find_by(subject_id: @params[:id])&.subject
    end
  end
end

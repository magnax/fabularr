# frozen_string_literal: true

module Seeds
  class Settings < ApplicationService
    def call
      Setting.where(key: 'projects').first_or_create
    end
  end
end

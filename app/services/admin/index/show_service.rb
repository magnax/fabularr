# frozen_string_literal: true

module Admin
  class Index::ShowService < ApplicationService
    def call
      {
        characters_count: Character.count,
        users_count: User.count
      }
    end
  end
end

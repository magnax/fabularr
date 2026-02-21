# frozen_string_literal: true

module Events
  module CreateService
    def self.call!(params)
      Event.create!(params)
    end
  end
end

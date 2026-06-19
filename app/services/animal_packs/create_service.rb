# frozen_string_literal: true

module AnimalPacks
  class CreateService < ApplicationService
    def initialize(location)
      @location = location
    end

    def call
      animals = Animal.all.sample(rand(1..4))
      animals.each do |animal|
        amount = rand(2..20)
        @location.animal_packs.create!(
          animal: animal,
          amount: amount,
          points: amount * animal.health
        )
      end
    end
  end
end

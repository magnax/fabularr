# frozen_string_literal: true

module Seeds
  class Animals < ApplicationService
    def initialize
      @animal_created = 0
      @animal_updated = 0
      @res_created = 0
      @res_updated = 0
    end

    def call
      Definitions::Animals::CONFIG.each do |animal_def|
        animal = create_animal!(animal_def)

        (animal_def[:res] || []).each do |res_def|
          create_animal_resources!(animal, res_def)
        end
      end

      Log.say "Animals: created #{@animal_created}, updated #{@animal_updated}"
      Log.say "Animal resources: created #{@res_created}, updated #{@res_updated}"
    end

    private

    def create_animal!(config)
      animal_params = config.except(:key, :res)

      animal = Animal.find_by(key: config[:key])

      if animal.present?
        animal.update!(**animal_params)
        @animal_updated += 1
      else
        animal = Animal.create!(key: config[:key], **animal_params)
        @animal_created += 1
      end

      animal
    end

    def create_animal_resources!(animal, res_def)
      res_type, res_key = res_def[:key].split('#')

      resource = Resource.where(key: res_key).first_or_create

      animal_res = animal.animal_resources.find_by(resource_id: resource.id, key: res_type)

      min, max = min_max(res_def[:amount])

      res_params = {
        min_amount: min,
        max_amount: max
      }

      if animal_res.present?
        animal_res.update!(**res_params)
        @res_updated += 1
      else
        animal.animal_resources.create!(resource: resource,
                                        key: res_type, **res_params)
        @res_created += 1
      end
    end

    def min_max(amount)
      return [amount, nil] if amount.is_a?(Integer)

      amount.minmax
    end
  end
end

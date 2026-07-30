# frozen_string_literal: true

animal_created = 0
animal_updated = 0
res_created = 0
res_updated = 0

Definitions::Animals::CONFIG.each do |animal_def|
  animal_params = animal_def.except(:key, :res)

  animal = Animal.find_by(key: animal_def[:key])

  if animal.present?
    animal.update!(**animal_params)
    animal_updated += 1
  else
    animal = Animal.create!(key: animal_def[:key], **animal_params)
    animal_created += 1
  end

  (animal_def[:res] || []).each do |res_def|
    res_type, res_key = res_def[:key].split('#')

    resource = Resource.where(key: res_key).first_or_create

    animal_res = animal.animal_resources.find_by(resource_id: resource.id, key: res_type)

    min, max = if res_def[:amount].is_a?(Integer)
                 [res_def[:amount], nil]
               else
                 res_def[:amount].minmax
               end

    res_params = {
      min_amount: min,
      max_amount: max
    }

    if animal_res.present?
      animal_res.update!(**res_params)
      res_updated += 1
    else
      animal.animal_resources.create!(resource: resource, key: res_type, **res_params)
      res_created += 1
    end
  end
end

Log.say "Animals: created #{animal_created}, updated #{animal_updated}"
Log.say "Animal resources: created #{res_created}, updated #{res_updated}"

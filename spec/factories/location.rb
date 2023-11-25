FactoryBot.define do
  factory :location, aliases: [:spawn_location] do
    locationtype_id { 1 }
    locationclass_id { 1 }
    name { 'Fabular City' }
    parent_location_id { nil }
  end

end

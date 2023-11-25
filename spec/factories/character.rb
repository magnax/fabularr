FactoryBot.define do
  sequence :name do |n|
    "Character #{n}"
  end

  factory :character, aliases: [ :named ] do
    name
    gender { "M" }
    location
    spawn_location
    user
  end
end

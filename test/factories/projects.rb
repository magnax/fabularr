# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                    :bigint           not null, primary key
#  amount                :integer
#  checked_at            :datetime
#  duration              :integer          default(0)
#  elapsed               :integer          default(0)
#  ready                 :boolean          default(FALSE)
#  unit                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  location_id           :integer
#  project_type_id       :integer
#  recipe_id             :bigint
#  starting_character_id :integer
#
# Indexes
#
#  index_projects_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
FactoryBot.define do
  factory :project do
    association :starting_character, factory: :character
    location
    project_type { FactoryBot.create(:project_type, key: 'build') }
    duration { 2000 }
    elapsed { 0 }

    amount { 1 }
    unit { 'g' }

    %i[build collect create_location discover_resource machinery road].each do |key|
      trait key do
        project_type { FactoryBot.create(:project_type, key: key.to_s) }
      end
    end

    trait :completed do
      duration { 1000 }
      elapsed { 1000 }
    end
  end
end

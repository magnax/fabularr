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
    project_type
    duration { 2000 }
    elapsed { 0 }

    amount { 1 }
    unit { 'g' }

    %i[discover_resource collect build].each do |key|
      trait key do
        project_type { FactoryBot.create(:project_type, key: key.to_s) }
      end
    end
  end
end

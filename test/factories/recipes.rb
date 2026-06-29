# frozen_string_literal: true

# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  base_speed  :integer
#  key         :string
#  recipe_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint
#
# Indexes
#
#  index_recipes_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#
FactoryBot.define do
  factory :recipe do
    recipe_type { Recipe::ITEM }
    key { 'stone_knife' }
    base_speed { 1000 }

    trait :machinery do
      recipe_type { Recipe::MACHINERY }
    end
  end
end

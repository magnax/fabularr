# frozen_string_literal: true

# == Schema Information
#
# Table name: recipe_instructions
#
#  id               :bigint           not null, primary key
#  amount           :integer
#  instruction_type :string
#  speed            :float
#  subject_type     :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipe_id        :bigint
#  subject_id       :integer
#
# Indexes
#
#  index_recipe_instructions_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
FactoryBot.define do
  factory :recipe_instruction do
    instruction_type { 'resource' }
    subject_id { 1 }
    subject_type { 'Resource' }
    amount { 1 }
    unit { 'grams' }

    trait :tool do
      instruction_type { 'tool' }
      subject { FactoryBot.create(:item_type) }
    end
  end
end

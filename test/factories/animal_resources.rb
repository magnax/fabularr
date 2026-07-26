# frozen_string_literal: true

# == Schema Information
#
# Table name: animal_resources
#
#  id          :bigint           not null, primary key
#  key         :string
#  max_amount  :integer
#  min_amount  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  animal_id   :bigint
#  resource_id :bigint
#
# Indexes
#
#  index_animal_resources_on_animal_id    (animal_id)
#  index_animal_resources_on_resource_id  (resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_id => animals.id)
#  fk_rails_...  (resource_id => resources.id)
#
FactoryBot.define do
  factory :animal_resource do
    key { AnimalResource::HUNT }
  end
end

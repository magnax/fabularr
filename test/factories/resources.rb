# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id               :bigint           not null, primary key
#  daily_rate       :float
#  eaten            :integer
#  heal             :integer          default(0)
#  integer          :integer
#  key              :string
#  material         :boolean          default(TRUE)
#  unit             :string           default("grams")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  resource_type_id :integer          is an Array
#  skill_id         :bigint
#
# Indexes
#
#  index_resources_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#
FactoryBot.define do
  factory :resource do
    key { 'MyString' }
    skill { FactoryBot.create(:skill, key: 'collecting') }

    %i[food material raw_food raw_resource].each do |key|
      trait key do
        resource_type_id { [FactoryBot.create(:resource_type, key: key.to_s).id] }
      end
    end
  end
end

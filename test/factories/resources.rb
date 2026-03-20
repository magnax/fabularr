# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id                  :bigint           not null, primary key
#  base_speed_per_unit :float
#  key                 :string
#  material            :boolean          default(TRUE)
#  unit                :string           default("grams")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_type_id    :integer          is an Array
#
FactoryBot.define do
  factory :resource do
    key { 'MyString' }

    %i[raw_food material].each do |key|
      trait key do
        resource_type_id { [FactoryBot.create(:resource_type, key: key.to_s).id] }
      end
    end
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id           :bigint           not null, primary key
#  left_at      :datetime
#  speed        :float            default(1.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  project_id   :integer
#
FactoryBot.define do
  factory :worker do
    project
    character

    trait :working do
      left_at { nil }
    end
  end
end

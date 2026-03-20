# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id           :bigint           not null, primary key
#  left_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  project_id   :integer
#
FactoryBot.define do
  factory :worker do
    project_id { 1 }
    character_id { 1 }
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  body                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  character_id          :integer
#  location_id           :integer
#  receiver_character_id :integer
#
FactoryBot.define do
  factory :event do
    body { 'MyText' }
    location_id { 1 }
    character_id { nil }
    receiver_character_id { nil }
  end
end

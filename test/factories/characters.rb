# frozen_string_literal: true

# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  gender            :string
#  name              :string
#  created_at        :datetime
#  updated_at        :datetime
#  location_id       :integer
#  spawn_location_id :integer
#  user_id           :integer
#
FactoryBot.define do
  sequence :name do |n|
    "Character #{n}"
  end

  factory :character, aliases: [:named] do
    name
    gender { 'M' }
    location
    spawn_location
    user
  end
end

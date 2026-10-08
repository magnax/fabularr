# frozen_string_literal: true

# == Schema Information
#
# Table name: notes
#
#  id           :bigint           not null, primary key
#  body         :string
#  editable     :boolean          default(TRUE)
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :bigint
#
# Indexes
#
#  index_notes_on_character_id  (character_id)
#
# Foreign Keys
#
#  fk_rails_...  (character_id => characters.id)
#
FactoryBot.define do
  factory :note do
    character
    title { Faker::Lorem.sentence(word_count: 4) }
    body { Faker::Lorem.paragraph }
  end
end

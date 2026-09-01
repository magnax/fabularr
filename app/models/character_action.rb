# frozen_string_literal: true

# == Schema Information
#
# Table name: character_actions
#
#  id           :bigint           not null, primary key
#  key          :string
#  subject_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :bigint
#  subject_id   :bigint
#
# Indexes
#
#  index_character_actions_on_character_id  (character_id)
#  index_character_actions_on_subject       (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (character_id => characters.id)
#
class CharacterAction < ApplicationRecord
  belongs_to :character
  belongs_to :subject, polymorphic: true

  scope :hunting, -> { where(key: HUNTING) }
  scope :recent, -> { where('created_at > ?', DateTime.current - 1.day) }

  HUNTING = 'hunting'
  ATTACK = 'attack'
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: character_skills
#
#  id           :bigint           not null, primary key
#  level        :float
#  status       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :bigint
#  skill_id     :bigint
#
# Indexes
#
#  index_character_skills_on_character_id  (character_id)
#  index_character_skills_on_skill_id      (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (character_id => characters.id)
#  fk_rails_...  (skill_id => skills.id)
#
class CharacterSkill < ApplicationRecord
  belongs_to :character
  belongs_to :skill

  scope :visible, -> { where(status: true) }

  delegate :key, to: :skill

  def description
    Skill::MAP_LEVELS[int_level]
  end

  def int_level
    level.floor
  end
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: char_names
#
#  id           :integer          not null, primary key
#  description  :text
#  name         :string
#  created_at   :datetime
#  updated_at   :datetime
#  character_id :integer
#  named_id     :integer
#
# Indexes
#
#  index_char_names_on_character_id               (character_id)
#  index_char_names_on_character_id_and_named_id  (character_id,named_id) UNIQUE
#  index_char_names_on_named_id                   (named_id)
#
class CharName < ApplicationRecord
  belongs_to :character
  belongs_to :named, class_name: 'Character'

  validates :character_id, presence: true
  validates :named_id, presence: true
  validates :name, presence: true

  def display_name
    name.gsub('%char%', named.default_name)
  end
end

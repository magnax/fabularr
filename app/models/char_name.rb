# frozen_string_literal: true

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

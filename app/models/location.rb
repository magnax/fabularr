# frozen_string_literal: true

class Location < ApplicationRecord
  has_many :characters, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :location_objects, dependent: :destroy
  has_many :location_resources, dependent: :destroy
  has_many :resources, through: :location_resources
  has_many :projects, dependent: :destroy
  has_many :workers, through: :projects

  belongs_to :location_type

  scope :random, -> { order('RANDOM()').limit(1) }

  def visible_characters
    characters
  end

  def hearable_characters
    # not final implementation!
    characters
  end
end

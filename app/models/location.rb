# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id                 :integer          not null, primary key
#  coords             :point
#  max_capacity       :integer
#  max_characters     :integer
#  name               :string
#  created_at         :datetime
#  updated_at         :datetime
#  location_class_id  :bigint
#  location_type_id   :integer
#  parent_location_id :integer
#
# Indexes
#
#  index_locations_on_location_class_id  (location_class_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_class_id => location_classes.id)
#
class Location < ApplicationRecord
  delegate :x, :y, to: :coords

  has_many :characters, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :location_objects, dependent: :destroy
  has_many :location_resources, dependent: :destroy
  has_many :resources, through: :location_resources
  has_many :projects, dependent: :destroy
  has_many :workers, through: :projects
  has_many :buildings, dependent: :destroy,
                       class_name: 'Building',
                       inverse_of: :parent_location

  belongs_to :location_type
  belongs_to :location_class
  belongs_to :parent_location, optional: true, class_name: 'Location'

  scope :random, -> { order('RANDOM()').limit(1) }

  def visible_characters
    characters
  end

  def hearable_characters
    # not final implementation!
    characters
  end

  def town?
    location_class.key == 'town'
  end
end

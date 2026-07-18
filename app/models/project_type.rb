# frozen_string_literal: true

# == Schema Information
#
# Table name: project_types
#
#  id         :bigint           not null, primary key
#  base_speed :integer
#  fixed      :boolean
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ProjectType < ApplicationRecord
  BUILD = 'build'
  COLLECT = 'collect'
  CREATE_LOCATION = 'create_location'
  DISCOVER_RESOURCE = 'discover_resource'
  MACHINERY = 'machinery'
  ROAD = 'road'

  EXPLORING_TYPES = [CREATE_LOCATION, DISCOVER_RESOURCE].freeze

  def exploring?
    key.in?(EXPLORING_TYPES)
  end

  # defines:
  # def collect?
  # def road?
  [COLLECT, ROAD].each do |key_name|
    define_method "#{key_name.downcase}?" do
      key == key_name
    end
  end
end

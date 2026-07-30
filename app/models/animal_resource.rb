# frozen_string_literal: true

# == Schema Information
#
# Table name: animal_resources
#
#  id          :bigint           not null, primary key
#  key         :string
#  max_amount  :integer
#  min_amount  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  animal_id   :bigint
#  resource_id :bigint
#
# Indexes
#
#  index_animal_resources_on_animal_id    (animal_id)
#  index_animal_resources_on_resource_id  (resource_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_id => animals.id)
#  fk_rails_...  (resource_id => resources.id)
#
class AnimalResource < ApplicationRecord
  belongs_to :animal
  belongs_to :resource

  scope :feed, -> { where(key: FEED) }
  scope :hunt, -> { where(key: HUNT) }
  scope :daily, -> { where(key: DAILY) }
  scope :slay, -> { where(key: SLAY) }

  DAILY = 'daily'     # what is produced daily (automatically) by domesticated animal
  FEED = 'feed'       # what should domesticated animal eat daily
  GATHER = 'gather'   # what can be gathered from an animal as a project
  HUNT = 'hunt'       # what drops after hunting
  SLAY = 'slay'       # what drops after butchering domesticated animal
end

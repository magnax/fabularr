# frozen_string_literal: true

# == Schema Information
#
# Table name: location_objects
#
#  id           :bigint           not null, primary key
#  amount       :float
#  damage       :float            default(0.0)
#  subject_type :string
#  unit         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  location_id  :bigint
#  subject_id   :integer
#
# Indexes
#
#  index_location_objects_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class LocationObject < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :location

  scope :resource, -> { where(subject_type: 'Resource') }
  scope :item, -> { where(subject_type: 'Item') }
end

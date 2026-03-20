# frozen_string_literal: true

# == Schema Information
#
# Table name: location_resources
#
#  id          :bigint           not null, primary key
#  amount      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer
#  resource_id :integer
#
class LocationResource < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :resource
end

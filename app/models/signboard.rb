# frozen_string_literal: true

# == Schema Information
#
# Table name: signboards
#
#  id          :bigint           not null, primary key
#  position    :integer          default(0)
#  text        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :bigint
#
# Indexes
#
#  index_signboards_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#
class Signboard < ApplicationRecord
  belongs_to :location
end

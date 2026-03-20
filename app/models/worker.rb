# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id           :bigint           not null, primary key
#  left_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  character_id :integer
#  project_id   :integer
#
class Worker < ApplicationRecord
  belongs_to :project
  belongs_to :character

  scope :active, -> { where(left_at: nil) }
end

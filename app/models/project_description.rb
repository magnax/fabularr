# frozen_string_literal: true

# == Schema Information
#
# Table name: project_descriptions
#
#  id               :bigint           not null, primary key
#  amount           :float
#  amount_needed    :float
#  description_type :string
#  subject_type     :string
#  unit             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  project_id       :bigint
#  subject_id       :integer
#
# Indexes
#
#  index_project_descriptions_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ProjectDescription < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :project

  scope :resource_in, -> { where(description_type: RESOURCE_IN) }
  scope :tool, -> { where(description_type: TOOL) }
  # Types:

  ITEM_IN = 'item_in'
  ITEM_OUT = 'item_out'
  MACHINE = 'machine'
  RESOURCE_IN = 'resource_in' # input
  RESOURCE_OUT = 'resource_out' # output
  TOOL = 'tool'
end

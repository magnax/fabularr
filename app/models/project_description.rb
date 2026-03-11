# frozen_string_literal: true

class ProjectDescription < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :project

  RESOURCE = 'resource'
  MATERIAL = 'material'
  ITEM = 'item'
  MACHINE = 'machine'
  TOOL = 'tool'
end

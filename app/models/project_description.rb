# frozen_string_literal: true

class ProjectDescription < ApplicationRecord
  belongs_to :subject, polymorphic: true

  RESOURCE = 'resource'
  MATERIAL = 'material'
  ITEM = 'item'
  MACHINE = 'machine'
  TOOL = 'tool'
end

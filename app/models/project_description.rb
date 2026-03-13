# frozen_string_literal: true

class ProjectDescription < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :project

  # Types:

  RESOURCE_IN = 'resource_in' # input
  RESOURCE_OUT = 'resource_out' # output
  ITEM_IN = 'item_in'
  ITEM_OUT = 'item_out'
  MACHINE = 'machine'
  TOOL = 'tool'
end

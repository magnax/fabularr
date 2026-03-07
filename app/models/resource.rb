# frozen_string_literal: true

class Resource < ApplicationRecord
  def resource_types
    ResourceType.where(id: resource_type_id)
  end
end

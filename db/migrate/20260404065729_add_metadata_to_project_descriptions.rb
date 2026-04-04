# frozen_string_literal: true

class AddMetadataToProjectDescriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :project_descriptions, :metadata, :json
  end
end

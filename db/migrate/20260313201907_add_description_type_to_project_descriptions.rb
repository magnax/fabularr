# frozen_string_literal: true

class AddDescriptionTypeToProjectDescriptions < ActiveRecord::Migration[8.1]
  def change
    change_table :project_descriptions, bulk: true do |t|
      t.column :description_type, :string
      t.column :amount_needed, :float
    end
  end
end

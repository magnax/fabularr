# frozen_string_literal: true

class ChangeMetadataInProjectDescriptions < ActiveRecord::Migration[8.1]
  def change
    reversible do |direction|
      direction.up do
        change_table :project_descriptions, bulk: true do |t|
          t.remove :metadata
          t.jsonb :metadata
        end
      end
      direction.down do
        change_table :project_descriptions, bulk: true do |t|
          t.remove :metadata
          t.json :metadata
        end
      end
    end
  end
end

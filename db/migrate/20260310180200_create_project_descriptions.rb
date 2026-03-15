# frozen_string_literal: true

class CreateProjectDescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :project_descriptions do |t|
      t.references :project, foreign_key: true
      t.integer :subject_id
      t.string :subject_type
      t.string :unit
      t.float :amount

      t.timestamps
    end
  end
end

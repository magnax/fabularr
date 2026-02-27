class CreateProjectTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :project_types do |t|
      t.string :key
      t.integer :base_speed
      t.boolean :fixed

      t.timestamps
    end
  end
end

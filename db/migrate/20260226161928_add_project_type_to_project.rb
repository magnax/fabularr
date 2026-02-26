class AddProjectTypeToProject < ActiveRecord::Migration[8.1]
  def change
    change_table :projects, bulk: true do
      add_column :projects, :project_type_id, :integer
      add_column :projects, :duration, :integer
      add_column :projects, :elapsed, :integer
    end
  end
end

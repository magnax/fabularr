class AddProjectTypeToProject < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :project_type_id, :integer
  end
end

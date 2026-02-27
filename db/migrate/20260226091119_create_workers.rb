class CreateWorkers < ActiveRecord::Migration[8.1]
  def change
    create_table :workers do |t|
      t.integer :project_id
      t.integer :character_id
      t.datetime :left_at

      t.timestamps
    end
  end
end

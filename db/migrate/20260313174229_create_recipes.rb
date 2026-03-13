class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :key
      t.integer :base_speed

      t.timestamps
    end
  end
end

class CreateItemTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :item_types do |t|
      t.string :key
      t.integer :weight

      t.timestamps
    end
  end
end

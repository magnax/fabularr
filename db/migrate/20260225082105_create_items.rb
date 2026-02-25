class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.integer :location_id
      t.integer :itemtype_id

      t.timestamps
    end
  end
end

class CreateTravellers < ActiveRecord::Migration[8.1]
  def change
    create_table :travellers do |t|
      t.references :start_location, foreign_key: { to_table: :locations }
      t.references :end_location, foreign_key: { to_table: :locations }
      t.references :subject, polymorphic: true
      t.float :direction
      t.float :speed, default: 100
      t.datetime :checked_at
      t.boolean :status, default: true

      t.timestamps
    end
  end
end

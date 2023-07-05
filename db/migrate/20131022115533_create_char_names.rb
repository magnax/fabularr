class CreateCharNames < ActiveRecord::Migration[4.2]
  def change
    create_table :char_names do |t|
      t.integer :character_id
      t.integer :named_id
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :char_names, :character_id
    add_index :char_names, :named_id
    add_index :char_names, [:character_id, :named_id], unique: true
    
  end
end

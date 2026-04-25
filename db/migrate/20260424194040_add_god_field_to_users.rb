# frozen_string_literal: true

class AddGodFieldToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :god, :boolean, default: false
  end
end

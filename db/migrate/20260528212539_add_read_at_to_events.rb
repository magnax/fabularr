# frozen_string_literal: true

class AddReadAtToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :read_at, :datetime, default: nil
  end
end

# frozen_string_literal: true

class CreateGameTime < ActiveRecord::Migration[8.1]
  def change
    create_table :game_times, &:timestamps
  end
end

# frozen_string_literal: true

class AddCoordinatesToSomeModels < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :coords, :point
    add_column :characters, :coords, :point
  end
end

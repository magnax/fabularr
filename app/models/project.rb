# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :starting_character, optional: false, class_name: 'Character'

  has_many :workers, dependent: :destroy
end

# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :starting_character, optional: false, class_name: 'Character'
  belongs_to :project_type

  has_many :workers, dependent: :destroy
end

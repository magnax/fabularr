# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :location, optional: true
end

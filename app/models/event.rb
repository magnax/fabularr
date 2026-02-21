class Event < ApplicationRecord
  belongs_to :location
  belongs_to :character
end

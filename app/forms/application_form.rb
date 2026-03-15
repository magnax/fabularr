# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::AttributeAssignment
  include ActiveModel::Attributes
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :character_id

  validates :character_id, presence: true
  validate :existing_character

  def update!(params)
    assign_attributes(**params)

    validate!
  end

  def existing_character
    errors.add(:character_id, :invalid) if character.blank?
  end

  def character
    @character ||= Character.find_by(id: character_id)
  end
end

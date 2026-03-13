# frozen_string_literal: true

# main class
class Character < ApplicationRecord
  MAX_CAPACITY = 15_000

  belongs_to :location
  belongs_to :spawn_location, class_name: 'Location'
  belongs_to :user

  has_many :char_names, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :inventory_objects, dependent: :destroy

  has_many :projects, through: :workers

  before_save { self.gender = gender.upcase }

  validates :gender, presence: true, format: { with: /\A[km]\z/i }
  validates :location_id, presence: true
  validates :name, presence: true
  validates :spawn_location_id, presence: true
  validates :user_id, presence: true

  def default_name
    gender == 'K' ? I18n.t('unknown_woman') : I18n.t('unknown_man')
  end

  def name_for(character)
    ch = char_name_for(character)
    if ch
      ch.display_name
    else
      return character.name if character.id == id

      character.default_name
    end
  end

  def char_name_for(character)
    @charnames = char_names.where(named: character)
    @charnames.first if @charnames.any?
  end

  def char_name_or_build(character)
    char_name_for(character) || char_names.build(named: character, name: name_for(character))
  end

  def project
    workers.active.last&.project
  end

  def age
    20 + (DateTime.current.to_i - created_at.to_i) / 86_400 / 20
  end

  def carrying_weight
    inventory_objects.sum(&:amount)
  end
end

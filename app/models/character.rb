# frozen_string_literal: true

# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  coords            :point
#  damage            :float            default(0.0)
#  gender            :string
#  hunger            :float            default(0.0)
#  name              :string
#  tiredness         :float            default(0.0)
#  created_at        :datetime
#  updated_at        :datetime
#  location_id       :integer
#  spawn_location_id :integer
#  user_id           :integer
#
class Character < ApplicationRecord
  MAX_CAPACITY = 15_000
  MIN_HEARABLE_DISTANCE = 3
  WEIGHT = 60_000

  belongs_to :location, optional: true
  belongs_to :spawn_location, class_name: 'Location'
  belongs_to :user

  has_many :char_names, dependent: :destroy
  has_many :location_names, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :visible_events, dependent: :destroy,
                            class_name: 'Event',
                            inverse_of: :receiver_character
  has_many :inventory_objects, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :travellers, dependent: :destroy, inverse_of: :subject

  has_many :projects, through: :workers

  before_save { self.gender = gender.upcase }

  validates :gender, presence: true, format: { with: /\A[km]\z/i }
  validates :name, presence: true
  validates :spawn_location_id, presence: true
  validates :user_id, presence: true

  def x
    location&.moveable? && location.coords ? location.coords.x : coords.x
  end

  def y
    location&.moveable? && location.coords ? location.coords.y : coords.y
  end

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
    inventory_objects.resource.sum(&:amount) + inventory_objects.item.sum { |i| i.subject.weight }
  end

  def char_id
    "<!--CHARID:#{id}-->"
  end

  def tools_keys
    inventory_objects.item.map { |i| i.subject.item_type.key }
  end

  def male?
    gender == 'M'
  end

  def project_info
    return if project.blank?

    {
      name: project.short_name,
      percent: ((project.elapsed.to_f / project.duration) * 100.0).round(1)
    }
  end

  def travelling?
    if vehicle.present?
      location.travellers.active.length == 1
    else
      travellers.active.length == 1
    end
  end

  def vehicle
    return unless location&.location_class&.moveable

    location
  end

  def can_start_travel?
    !travelling? && (location&.town? || location&.location_class&.moveable)
  end

  def traveller
    travellers.active.first
  end

  def toplevel_location
    return if location.blank?

    loc = location
    loc = loc.parent_location while loc.parent_location
    loc
  end

  def hunger_level
    if hunger >= 90
      'agony'
    elsif hunger >= 80
      'skinny'
    elsif hunger >= 50
      'hungry'
    end
  end

  def damage_level
    if damage >= 90
      'agony'
    elsif damage >= 80
      'wounded'
    elsif damage >= 50
      'scratch'
    end
  end

  def foods
    raw_food_id = ResourceType.find_by(key: ResourceType::RAW_FOOD)&.id
    return [] if raw_food_id.blank?

    inventory_objects
      .resource
      .joins('JOIN resources ON resources.id = inventory_objects.subject_id')
      .where("#{raw_food_id} = any(resources.resource_type_id)")
      .order('resources.eaten DESC')
  end

  def decade
    d = (GameTime.last.days / GameTime::DAYS_IN_YEAR + 20) / 10 * 10
    d = 100 if d > 100

    d
  end
end

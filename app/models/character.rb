#encoding = utf-8
class Character < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :spawn_location, class_name: "Location"

  has_many :char_names, dependent: :destroy

  before_save { self.gender = gender.upcase }

  validates :user_id, presence: true
  validates :name, presence: true
  validates :gender, presence: true, format: { with: /\A[km]\z/i }
  validates :location_id, presence: true
  validates :spawn_location_id, presence: true

  def default_name
  	self.gender == 'K' ? I18n.t('unknown_woman') : I18n.t('unknown_man')
  end

  def name_for(character)
    ch = char_name_for(character)
  	if ch
  		ch.display_name
  	else
  		return character.name if character.id == self.id
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

end

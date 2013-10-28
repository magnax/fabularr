#encoding = utf-8
class Character < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :spawn_location

  has_many :char_names, dependent: :destroy

  before_save { self.gender = gender.upcase }

  validates :user_id, presence: true
  validates :gender, presence: true, format: { with: /\A[km]\z/i }
  validates :location_id, presence: true
  validates :spawn_location_id, presence: true

  def default_name
  	self.gender == 'K' ? 'nieznana kobieta' : 'nieznany mężczyzna'
  end

  def name_for(character)
  	if char_names.where(named_id: character.id).count > 0 
  		char_names.where(named_id: character.id).first.name
	else
		return character.name if character.id == self.id
  		character.default_name
  	end
  end

end

#encoding = utf-8
class CharName < ActiveRecord::Base
	belongs_to :character
	belongs_to :named, class_name: "Character"

	validates :character_id, presence: true
	validates :named_id, presence: true
	validates :name, presence: true

end

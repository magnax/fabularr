class Character < ActiveRecord::Base
	belongs_to :user
	before_save { self.gender = gender.upcase }

  validates :user_id, presence: true
  validates :gender, presence: true, format: { with: /\A[km]\z/i }

end

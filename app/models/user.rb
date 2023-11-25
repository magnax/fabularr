# frozen_string_literal: true

class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	
  has_many :characters

  before_save { self.email = email.downcase }	
  before_create :create_remember_token

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  scope :recently_created, -> { where('created_at <= ?', Date.current - 2.days ) }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def create_character(params, location_id)
    characters.build(params.merge({ spawn_location_id: location_id, location_id: location_id }))
  end

  def can_create_new_character?
  	self.characters.count < 15
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end

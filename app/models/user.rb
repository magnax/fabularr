# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z]+)*\.[a-z]+\z/i
  MAX_CHARACTERS = 15

  has_many :characters, dependent: :destroy
  has_many :sessions, dependent: :destroy

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  scope :recently_created, -> { where('created_at <= ?', Date.current - 2.days) }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def can_create_character?
    characters.count < MAX_CHARACTERS
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end

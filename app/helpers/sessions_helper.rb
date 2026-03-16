# frozen_string_literal: true

module SessionsHelper
  def current_character
    @current_character ||= Character.find_by(id: cookies[:character_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= Current.user
  end
end

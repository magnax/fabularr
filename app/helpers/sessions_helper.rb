# frozen_string_literal: true

module SessionsHelper
  def current_character_set
    redirect_to list_url, notice: I18n.t('flash.notice.please_choose_char') unless current_character?
  end

  def current_character?
    !current_character.nil?
  end

  def current_character
    character_token = cookies[:character_token]
    @current_character ||= Character.find_by(id: character_token)
  end

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to login_url, notice: I18n.t('flash.notice.please_login')
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'static'

  before_action :correct_user, only: %i[edit update]
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      flash[:success] = I18n.t 'flash.success.welcome'
      redirect_to list_path
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @characters = @user.characters.includes(location: %i[location_type parent_location])
  end

  def edit; end

  def update
    @user.update!(user_params)
    flash[:success] = I18n.t 'flash.success.profile_saved'

    redirect_to list_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # def signed_in_user
  #   redirect_to login_url, notice: I18n.t('flash.notice.please_login') unless signed_in?
  # end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user == @user
  end
end

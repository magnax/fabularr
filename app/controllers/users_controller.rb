# encoding: utf-8
class UsersController < ApplicationController
  layout 'static'

  before_action :signed_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
	    flash[:success] = I18n.t 'flash.success.welcome'
      redirect_to list_path
    else
      render 'new'
    end
  end

  def show
  	@user = current_user
  end

  def edit

  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t 'flash.success.profile_saved'
      redirect_to list_path
    else
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # Before filters

  def signed_in_user
    redirect_to login_url, notice: I18n.t('flash.notice.please_login') unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end

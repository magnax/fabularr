# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to list_path
    else
      flash.now[:error] = t :invalid_credentials
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end

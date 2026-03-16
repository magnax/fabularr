# frozen_string_literal: true

class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new; end

  def create
    user = User.authenticate_by(params.require(:session).permit(:email, :password))

    if user
      start_new_session_for user
      redirect_to list_path
    else
      flash.now[:error] = t :invalid_credentials
      render 'new'
    end
  end

  def destroy
    terminate_session
    redirect_to root_url
  end
end

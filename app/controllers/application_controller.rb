# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  rescue_from Users::TooManyCharactersError, with: :render_too_many_characters
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  private

  def render_too_many_characters
    flash[:error] = I18n.t 'flash.errors.cannot_create'

    redirect_to list_path
  end

  def render_record_invalid(err)
    flash[:error] = I18n.t 'flash.errors.invalid_record'
    if "#{request.original_url}/new" == request.referer
      render :new, locals: { record: err.record }
    else
      flash[:errors] = err.record.errors.full_messages.join("\n")
      redirect_to request.referer, params: request.params
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end

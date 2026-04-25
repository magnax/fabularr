# frozen_string_literal: true

class Admin::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'admin'

  include SessionsHelper
  include Authentication

  def default_breadcrumbs(final: false)
    admin = final ? 'Admin' : { text: 'Admin', link: admin_url }
    [{ text: 'Fabularr', link: events_url }, :separator, admin]
  end
end

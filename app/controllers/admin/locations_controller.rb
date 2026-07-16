# frozen_string_literal: true

class Admin::LocationsController < Admin::ApplicationController
  def index
    render locals: { locations: Location.town.all, breadcrumbs: breadcrumbs }
  end

  def show
    render locals: Admin::Locations::ShowService.call(params[:id], default_breadcrumbs)
  end

  private

  def breadcrumbs
    default_breadcrumbs << :separator << 'Locations'
  end
end

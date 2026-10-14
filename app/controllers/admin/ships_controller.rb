# frozen_string_literal: true

class Admin::ShipsController < Admin::ApplicationController
  def index
    render locals: { ships: Ship.all, breadcrumbs: breadcrumbs }
  end

  private

  def breadcrumbs
    default_breadcrumbs << :separator << 'Ships'
  end
end

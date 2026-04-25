# frozen_string_literal: true

class Admin::CharactersController < Admin::ApplicationController
  def index
    render locals: { characters: Character.all, breadcrumbs: breadcrumbs }
  end

  private

  def breadcrumbs
    default_breadcrumbs << :separator << 'Characters'
  end
end

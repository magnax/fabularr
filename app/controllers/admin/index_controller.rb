# frozen_string_literal: true

class Admin::IndexController < Admin::ApplicationController
  def index
    render locals: Admin::Index::ShowService.call.merge({ breadcrumbs: default_breadcrumbs(final: true) })
  end
end

# frozen_string_literal: true

class StaticPagesController < ApplicationController
  allow_unauthenticated_access only: :home

  layout 'static'

  def home; end
end

# frozen_string_literal: true

class MapsController < ApplicationController
  def index
    image = Maps::GenerateService.call(current_character)

    send_data image[:data], type: image[:content_type], disposition: 'inline'
  end
end

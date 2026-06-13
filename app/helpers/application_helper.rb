# frozen_string_literal: true

module ApplicationHelper
  def character_placement_icon(char)
    image_tag("#{char[:location_icon]}.png", title: char[:location_icon])
  end
end

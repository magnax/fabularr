# frozen_string_literal: true

module Admin::CharactersHelper
  def coords(obj)
    obj.coords.present? ? "(#{obj.x}, #{obj.y})" : '-'
  end
end

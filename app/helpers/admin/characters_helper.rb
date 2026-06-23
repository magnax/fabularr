# frozen_string_literal: true

module Admin::CharactersHelper
  def coords(obj)
    obj.coords.present? ? "(#{obj.x.round(2)}, #{obj.y.round(2)})" : '-'
  end
end

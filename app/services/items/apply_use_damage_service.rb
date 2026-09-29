# frozen_string_literal: true

module Items
  class ApplyUseDamageService < ApplicationService
    def initialize(item)
      @item = item
    end

    # TODO: Add tests, implement total damage
    def call
      @item.update!(damage: @item.damage - @item.item_type.rot_use)
    end
  end
end

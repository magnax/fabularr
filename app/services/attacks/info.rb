# frozen_string_literal: true

module Attacks::Info
  private

  def weapons
    [bare_fist] + inventory_weapons
  end

  def bare_fist
    [I18n.t('items.bare_fist'), 4]
  end

  def inventory_weapons
    @character.inventory_objects.weapon.map do |weapon|
      [weapon.subject.key, weapon.subject.item_type.attack]
    end
  end

  def force
    (0..10).map do |i|
      OpenStruct.new(id: i, tag: i)
    end
  end
end

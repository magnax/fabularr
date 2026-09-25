# frozen_string_literal: true

module Attacks::AttackHelper
  def damage
    damage_points * (@params[:force].to_i / 10.0)
  end

  def damage_points
    # TODO: adjust by character skill
    return 4 if weapon.blank?

    weapon.item.attack
  end

  def weapon_key
    return I18n.t('items.bare_fist') if weapon.blank?

    [
      I18n.t("items.damage.#{weapon.item.damage_key}"),
      I18n.t("items.#{weapon.item.key}")
    ].join(' ')
  end

  def weapon
    @weapon ||= @character.inventory_objects.find_by(id: @params[:inventory_object_id])
  end
end

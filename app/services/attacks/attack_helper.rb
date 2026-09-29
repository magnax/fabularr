# frozen_string_literal: true

module Attacks::AttackHelper
  def total_damage
    @total_damage ||= begin
      dp = hit_damage - saved
      return 0 if dp.negative?

      dp
    end
  end

  def hit_damage
    @hit_damage ||= damage_points * (@params[:force].to_i / 10.0)
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

  def defend
    if protection.present?
      I18n.t('events.hit.character.defend', skill: skill,
                                            saved: saved,
                                            protection: protection_info)
    else
      I18n.t('events.hit.character.defend_no_protection')
    end
  end

  def protection_info
    [
      I18n.t("items.damage.#{protection.item.damage_key}"),
      I18n.t("items.#{protection.item.key}")
    ].join(' ')
  end

  def saved
    return 0 if protection.blank?

    protection.subject.item_type.defense
  end

  def weapon
    @weapon ||= @character.inventory_objects.find_by(id: @params[:inventory_object_id])
  end

  def protection
    @protection ||= begin
      return unless protections.any?

      protections.min_by { |w| w.item.damage }
    end
  end

  def protections
    target_character.inventory_objects.protection
  end
end

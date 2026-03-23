# frozen_string_literal: true

module Events::BodyHelper
  def drop_item_body
    I18n.t('events.drop_item',
           item: I18n.td("items.#{subject.item_type.key}"))
  end

  def drop_resource_body
    I18n.t('events.drop_resource',
           res: I18n.td("resources.#{subject.key}"),
           amount: calculated_amount.to_i,
           unit: I18n.td(location_object.unit))
  end

  def drop_resource_others_body
    I18n.t('events.drop_resource_others',
           character_link: character.char_id,
           res: I18n.td("resources.#{subject.key}"))
  end

  def drop_item_others_body
    I18n.t('events.drop_item_others',
           character_link: character.char_id,
           item: I18n.td("items.#{subject.item_type.key}"))
  end
end

# frozen_string_literal: true

module Attacks
  class Animal < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
      @target_ids = params.delete(:target_ids).map(&:to_i).reject(&:zero?)
    end

    def call
      check_packs!

      apply_damage!
    end

    private

    def check_packs!
      target_packs.each do |pack|
        action = @character.character_actions.find_by(
          key: CharacterAction::HUNTING,
          subject: pack
        )
        next if action.blank?

        time_diff = DateTime.current.to_i - action.updated_at.to_i

        raise Attacks::Animals::NotEnoughTimeError if time_diff < GameTime::DAY
      end
    end

    def apply_damage!
      target_packs.each do |pack|
        animal = pack.animal
        points, amount = calculate_damage(pack, animal)

        if amount < pack.amount
          drop_resources!(animal)
          create_kill_events!(animal_name(animal.key))
        else
          create_events!(animal_name(animal.key), damage)
        end

        pack.update!(points: points, amount: amount)
        increase_hunting!
        create_action!(pack)
      end
    end

    def create_action!(pack)
      action = @character.character_actions.where(
        key: CharacterAction::HUNTING, subject: pack
      ).first_or_create

      action.update!(updated_at: DateTime.current)
    end

    def increase_hunting!
      CharacterSkills::IncreaseOnceService.call(@character.hunting)
    end

    def animal_name(key)
      I18n.t("animals.#{key}.s")
    end

    def calculate_damage(pack, animal)
      points = pack.points - damage
      amount = (points.to_i / animal.health.to_i) + 1

      [points, amount]
    end

    def drop_resources!(animal)
      animal.animal_resources.hunt.each do |res|
        amount = (res.min_amount..res.max_amount).to_a.sample
        InventoryObjects::IncreaseAmountService.call(
          @character, res.resource.key, amount
        )
      end
    end

    def create_events!(key, damage)
      body = I18n.t('events.hit.animal', key: key, damage: damage.to_i,
                                         skill: skill, weapon: weapon_key)
      Events::CreateAndBroadcastService.call(@character, body)

      create_location_events!(key)
    end

    def create_kill_events!(key)
      body = I18n.t('events.hit.animal_kill', key: key, skill: skill,
                                              weapon: weapon_key)
      Events::CreateAndBroadcastService.call(@character, body)

      create_location_kill_events!(key)
    end

    def create_location_events!(key)
      body = I18n.t(
        'events.hit.animal_other',
        key: key, skill: skill,
        weapon: weapon_key, character_link: @character.char_id
      )

      Events::CreateEventForAllService.call(
        @character.location.visible_characters, body, except: @character
      )
    end

    def create_location_kill_events!(key)
      body = I18n.t(
        'events.hit.animal_kill_other',
        key: key, skill: skill,
        weapon: weapon_key, character_link: @character.char_id
      )

      Events::CreateEventForAllService.call(
        @character.location.visible_characters, body, except: @character
      )
    end

    def skill
      key = Skill::MAP_LEVELS[@character.hunting&.level&.floor]
      I18n.t("skills.#{key}")
    end

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

    def target_packs
      @target_packs ||= location.animal_packs.where(animal_id: @target_ids)
    end

    def location
      @location ||= @character.location
    end
  end
end

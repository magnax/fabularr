# frozen_string_literal:true

module Characters
  class FeedService < ApplicationService
    HUNGER_POINTS = 5
    HUNGER_DECREASE_POINTS = 3

    def initialize(character_id)
      @character_id = character_id
    end

    def call
      eat_and_calculate_hunger!
    end

    private

    def eat_and_calculate_hunger!
      if foods.empty?
        new_hunger = character.hunger + HUNGER_POINTS
        new_hunger = 100 if new_hunger >= 100
      else
        return if hunger_change.zero?

        new_hunger = character.hunger + hunger_change
      end

      character.update!(hunger: new_hunger)
      create_hunger_event!
    end

    def create_hunger_event!
      return unless hunger_change.positive?

      create_event!(I18n.t('events.hungry'))
    end

    def hunger_change
      @hunger_change ||= begin
        eaten = eaten_points
        if character.hunger.positive? && eaten == HUNGER_POINTS
          -HUNGER_DECREASE_POINTS
        else
          HUNGER_POINTS - eaten
        end
      end
    end

    def eaten_points
      remaining = 1

      foods.each do |food|
        remaining = eat(food, remaining)
        break if remaining.zero?
      end

      HUNGER_POINTS * (1 - remaining)
    end

    def eat(food, remaining)
      if food.amount >= (remaining * food.subject.eaten)
        eat_food!(food, remaining * food.subject.eaten)
        0
      else
        to_eat = food.amount / food.subject.eaten
        eat_food!(food, food.amount)
        remaining - to_eat
      end
    end

    def eat_food!(resource, amount)
      resource.update!(amount: resource.amount - amount)
      if resource.amount.zero?
        body = I18n.t('events.eaten_all', res: resource.subject.key)
        resource.destroy
      else
        body = I18n.t('events.eaten', amount: amount, res: resource.subject.key)
      end

      create_event!(body)
    end

    def create_event!(body)
      event = Event.create!(
        body: body,
        receiver_character: @character
      )
      ActionCable.server.broadcast("char_#{@character.id}", { type: 'event', event_id: event.id })
    end

    def foods
      @foods ||= character.foods
    end

    def character
      @character ||= Character.find_by(id: @character_id)
    end
  end
end

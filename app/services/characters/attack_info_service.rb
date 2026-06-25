# frozen_string_literal: true

require 'ostruct'

module Characters
  class AttackInfoService < ApplicationService
    def initialize(character, params)
      @character = character
      @params = params
    end

    def call
      {
        force: force,
        target_id: @params[:character_id],
        weapons: weapons.sort { |w| w[1] }
      }
    end

    private

    def weapons
      [bare_fist]
    end

    def bare_fist
      [I18n.t('items.bare_fist'), 4]
    end

    def force
      (0..10).map do |i|
        OpenStruct.new(id: i, tag: i)
      end
    end
  end
end

# frozen_string_literal: true

class AnimalsController < ApplicationController
  def attack
    render locals: Animals::AttackInfoService.call(current_character)
  end
end

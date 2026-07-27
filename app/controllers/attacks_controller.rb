# frozen_string_literal: true

class AttacksController < ApplicationController
  def create
    Attacks::CreateService.call(current_character, attack_params)

    redirect_to events_url
  rescue Attacks::Animal::NotEnoughTimeError
    render_error I18n.t('errors.attacks.animal.not_enough_time')
  end

  private

  def attack_params
    params.require(:event).permit(:target_id, :target_type, :weapon, :force, target_ids: [])
  end
end

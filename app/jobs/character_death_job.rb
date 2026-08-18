# frozen_string_literal: true

class CharacterDeathJob
  include Sidekiq::Job

  def perform(character_id)
    Characters::DeathService.call(character_id)
  end
end

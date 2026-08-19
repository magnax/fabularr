# frozen_string_literal: true

module Projects::EndEvents
  def notify_starting_character
    return unless starting_character.location == project.location

    event = Event.create!(
      body: body,
      receiver_character: starting_character
    )

    Events::BroadcastService.call(starting_character.id, event.id)
  end

  def starting_character
    @starting_character ||= project.starting_character
  end
end

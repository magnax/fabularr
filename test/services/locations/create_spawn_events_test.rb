# frozen_string_literal: true

require 'test_helper'

class Locations::CreateSpawnEventsTest < ActiveSupport::TestCase
  def call_service(location, character)
    Locations::CreateSpawnEvents.call(location, character)
  end

  test 'creates proper location type event' do
    forest_type = create(:location_type, key: 'forest')
    location = create(:location, location_type: forest_type)
    character = create(:character, spawn_location: location, location: location)

    call_service(location, character)

    char_events = Event.where(receiver_character: character)
    assert_includes char_events.pluck(:body), 'You are in some place which looks like forest.'
  end

  test 'creates proper projects info type event' do
    location = create(:location)
    character = create(:character, spawn_location: location, location: location)
    create(:project, location: location, duration: 1000, elapsed: 1000)
    create(:project, location: location)
    project = create(:project, location: location)
    create(:worker, character: character, project: project)

    call_service(location, character)

    char_events = Event.where(receiver_character: character)
    assert_includes char_events.pluck(:body), 'You see 2 ongoing projects, 1 of which someone is currently working on.'
  end

  # You see 13 ongoing projects or other activities, 4 of which someone is currently working on.

  # Znajdujesz się w miejscu, które można określić ogólnie jako las. To miejsce stanowi źródło 16 różnych rodzajów surowców, które mogą być przez ciebie pozyskiwane, spostrzegasz również 20 zwierząt. # rubocop:disable Layout/LineLength
  # W twoim inwentarzu nie ma żadnych przedmiotów ani surowców.
  # Znajduje się tutaj 14 pojazdów i budynków.
  # Widzisz też 22 innych osób w tym miejscu.
  # Na ziemi leży 43 przedmiotów, z czego 7 to notatki, które możesz przeczytać.
  # Widzisz 13 rozpoczętych projektów lub innych czynności, z czego nad 4 ktoś obecnie pracuje.
end

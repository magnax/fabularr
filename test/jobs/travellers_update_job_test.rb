# frozen_string_literal: true

require 'test_helper'

class TravellersUpdateJobTest < ActiveSupport::TestCase
  def setup
    location_type = create(:location_type)
    Maps.expects(:location_type).with(anything, anything)
        .times(0..1).returns(location_type)
  end

  def call_job
    TravellersUpdateJob.perform_sync
  end

  test 'update position' do
    time = DateTime.parse('2026-04-11 09:00')
    character = create(:character, coords: { x: 200, y: 300 })
    create(:traveller, subject: character,
                       direction: 135, speed: 100, checked_at: time)

    Timecop.travel(time + 1.hour)
    call_job

    assert_equal 202.2, character.reload.x.round(1)
    assert_equal 302.2, character.y.round(1)
    Timecop.unfreeze
  end

  test "don't arrive to start location" do
    time = DateTime.parse('2026-04-11 09:00')
    location = create(:location, coords: { x: 200, y: 300 })
    character = create(:character, coords: { x: 200, y: 300 })
    create(:traveller, subject: character, start_location: location,
                       direction: 135, speed: 100, checked_at: time)

    Timecop.travel(time + 10.minutes)
    call_job

    assert_equal 200.4, character.reload.x.round(1)
    assert_equal 300.4, character.y.round(1)
    Timecop.unfreeze
  end

  test 'arriving to location when travelling on road' do
    time = DateTime.parse('2026-04-11 09:00')
    character = create(:character, location: nil, coords: { x: 200, y: 299 })
    location_1 = create(:location, coords: { x: 200, y: 200 })
    location_2 = create(:location, coords: { x: 200, y: 300 })
    road = create(:road, location_1: location_1, location_2: location_2)
    create(:traveller, subject: character, start_location: location_1,
                       direction: 180, speed: 100, road: road, checked_at: time)

    Timecop.travel(time + 22.minutes)
    assert_difference -> { Event.count } => 1 do
      call_job
    end
    Timecop.unfreeze

    assert_equal location_2, character.reload.location
    assert_not character.travelling?

    ev = Event.where(receiver_character: character).sole
    assert_equal "You arrived at <!--LOCID:#{location_2.id}-->", ev.body
  end

  test 'schedule next run' do
    create(:setting, key: 'travels', value: '1')

    Sidekiq.testing!(:fake) do
      call_job
      assert_equal 1, TravellersUpdateJob.jobs.size
    end
  end
end

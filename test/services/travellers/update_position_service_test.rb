# frozen_string_literal: true

require 'test_helper'

class TravellersUpdatePositionServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character, coords: { x: 100, y: 100 })
  end

  def call_service(traveller)
    Travellers::UpdatePositionService.call(traveller)
  end

  test 'simple update - north (straight up)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 0)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 100, @character.reload.x.round(4)
    assert_equal 94.792, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - north-east (up and right)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 45)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 103.6826, @character.reload.x.round(4)
    assert_equal 96.3174, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - east (straight right)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 90)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 105.208, @character.reload.x.round(4)
    assert_equal 100, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - south-east (down and right)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 135)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 103.6826, @character.reload.x.round(4)
    assert_equal 103.6826, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - south (straight down)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 180)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 100, @character.reload.x.round(4)
    assert_equal 105.208, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - south-west (down and left)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 225)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 96.3174, @character.reload.x.round(4)
    assert_equal 103.6826, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - west (straight left)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 270)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 94.792, @character.reload.x.round(4)
    assert_equal 100, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - north-west (up and left)' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 315)

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 96.3174, @character.reload.x.round(4)
    assert_equal 96.3174, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end

  test 'simple update - direction > 360' do
    time = DateTime.parse('2026-02-01 11:00:00')
    Timecop.freeze(time)
    traveller = create(:traveller, subject: @character, speed: 100, direction: 675) # == 315

    Timecop.freeze(time + 100.minutes)
    call_service(traveller)

    assert_equal 96.3174, @character.reload.x.round(4)
    assert_equal 96.3174, @character.y.round(4)
    assert_equal time + 100.minutes, traveller.reload.checked_at
  end
end

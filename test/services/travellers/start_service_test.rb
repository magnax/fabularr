# frozen_string_literal: true

require 'test_helper'

class TravellersStartServiceTest < ActiveSupport::TestCase
  def setup
    @location = create(:location, coords: { x: 100, y: 150 })
    @character = create(:character, location: @location, coords: nil)
  end

  def call_service(params)
    Travellers::StartService.call(@character, params)
  end

  test 'create new traveller record' do
    params = {
      direction: 90
    }

    assert_difference -> { Traveller.count } => 1,
                      -> { Event.count } => 1 do
      call_service(params)
    end

    t = Traveller.last
    assert_equal @character, t.subject
    assert_equal params[:direction], t.direction

    assert_equal 100, @character.reload.x
    assert_equal 150, @character.y
    assert_nil @character.location_id
    assert @character.travelling?

    assert_equal 1, Traveller.active.count

    ev = Event.last
    assert_equal "You're leaving "\
                 "<!--LOCID:#{@location.id}-->"\
                 ' heading in direction: 90',
                 ev.body
  end
end

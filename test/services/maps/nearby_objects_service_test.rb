# frozen_string_literal: true

require 'test_helper'

class MapsNearbyObjectsServiceTest < ActiveSupport::TestCase
  def setup
    @light = create(:machinery, key: Machinery::LIGHT)
    @location = create(:location, coords: { x: 100, y: 100 })
    @character = create(:character, location: @location)
  end

  def call_service
    Maps::NearbyObjectsService.call(@character)
  end

  def create_lighthouse(pos_x, pos_y, lit: false)
    lighthouse = create(:location, :lighthouse, coords: { x: pos_x, y: pos_y })
    return lighthouse unless lit

    machine = create(:location_object, location: lighthouse, subject: @light)
    project = create(:project, location: lighthouse)
    create(:project_description, :machine, subject: machine, project: project)

    lighthouse
  end

  test 'return nil if character not travelling' do
    assert_nil call_service
  end

  test 'returns proper data for visible lighthouses' do
    ship = create(:location, :ship, parent_location: nil, coords: { x: 100, y: 100 })
    @character.update!(location: ship)
    create(:traveller, subject: ship)

    l_very_close = create_lighthouse(105, 112) # 13px
    l_close = create_lighthouse(100, 130) # 30px
    l_far = create_lighthouse(140, 164, lit: true) # 75px
    l_very_far = create_lighthouse(170, 233, lit: true) # 150px
    create_lighthouse(170, 293, lit: true) # 205px

    res = call_service

    assert_equal 4, res.length

    l_1 = res.filter { |l| l[:id] == l_very_close.id }.first
    assert_equal 'very close-by', l_1[:distance]
    assert_equal l_very_close.name, l_1[:name]
    assert_equal 157, l_1[:direction]
    assert_equal 'lighthouse', l_1[:type]

    l_2 = res.filter { |l| l[:id] == l_close.id }.first
    assert_equal 'fairly close-by', l_2[:distance]
    assert_equal l_close.name, l_2[:name]
    assert_equal 180, l_2[:direction]

    l_3 = res.filter { |l| l[:id] == l_far.id }.first
    assert_equal 'far away', l_3[:distance]
    assert_nil l_3[:name]
    assert_equal 148, l_3[:direction]

    l_4 = res.filter { |l| l[:id] == l_very_far.id }.first
    assert_equal 'very far away', l_4[:distance]
    assert_nil l_4[:name]
    assert_equal 152, l_4[:direction]
  end
end

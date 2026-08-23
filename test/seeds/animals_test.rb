# frozen_string_literal: true

require 'test_helper'

class SeedsAnimalsTest < ActiveSupport::TestCase
  test 'works' do
    AnimalPack.destroy_all

    assert_difference -> { Animal.count } => 7,
                      -> { AnimalResource.count } => 32 do
      Seeds::Animals.call
    end

    cat = Animal.find_by(key: 'cat')
    assert_equal 3, cat.animal_resources.length

    res = Resource.find_by(key: 'fresh_dung')
    animal_res = cat.animal_resources.hunt.find_by(resource_id: res.id)
    assert_equal 20, animal_res.min_amount
    assert_equal 50, animal_res.max_amount

    sheep = Animal.find_by(key: 'sheep')
    assert_equal 13, sheep.animal_resources.length

    res = Resource.find_by(key: 'hay')
    animal_res = sheep.animal_resources.feed.find_by(resource_id: res.id)
    assert_equal 75, animal_res.min_amount
    assert_nil animal_res.max_amount
  end
end

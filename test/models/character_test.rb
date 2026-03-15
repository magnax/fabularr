# frozen_string_literal: true

require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  test 'carrying_weight' do
    character = create(:character)
    iron = create(:resource, key: 'iron')
    sand = create(:resource, key: 'sand')
    create(:inventory_object, character: character, subject: iron, amount: 200)
    create(:inventory_object, character: character, subject: sand, amount: 300)

    assert_equal 500, character.carrying_weight
  end
end

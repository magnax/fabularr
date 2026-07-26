# frozen_string_literal: true

require 'test_helper'

class AttacksAnimalPostTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @location = create(:location)
    @character = create(:character, user: @user, location: @location)
    login(@user, @character)
  end

  test 'valid params' do
    cat = create(:animal, key: 'cat')
    create(:animal_pack, animal: cat, location: @location, amount: 1, points: 100)

    params = {
      event: {
        target_ids: [cat.id],
        target_type: 'animal',
        force: 10,
        weapon: 0
      }
    }

    assert_difference -> { Event.count } => 1 do
      post '/attack', params: params.as_json
    end
  end
end

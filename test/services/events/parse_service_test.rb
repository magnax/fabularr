# frozen_string_literal: true

require 'test_helper'

class Events::ParseServiceTest < ActiveSupport::TestCase
  def setup
    @current_character = create(:character, gender: 'K')
    @location = create(:location)
  end

  def call_service(event)
    Events::ParseService.call(event, @current_character)
  end

  def expected_character_link(character_id, gender = 'woman')
    "<a class=\"character-name\" data-char-id=\"#{character_id}\""\
      " href=\"/characters/#{character_id}/name\">unknown #{gender}</a>"
  end

  test 'parse simple event (ie. weather change)' do
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character_id: nil)

    result = call_service(event)

    assert_equal event.body, result[:body]
    assert_nil result[:lead]
  end

  test 'parse talk event from some character' do
    character = create(:character, gender: 'M')
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: character)

    result = call_service(event)

    assert_equal event.body, result[:body]
  end

  test 'still parse talk event from dead character' do
    character = create(:character, gender: 'M', status: false)
    event = create(:event, body: "You see <!--CHARID:#{character.id}--> dies.",
                           location: @location, character: @current_character)

    result = call_service(event)

    assert_equal 'You see '\
                 "#{expected_character_link(character.id, 'man')} dies.", result[:body]
  end

  test 'parse talk event from the same character' do
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: @current_character)

    result = call_service(event)

    assert_equal event.body, result[:body]
  end

  test 'parse private talk event from the other character' do
    character = create(:character, gender: 'K')
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: character,
                           receiver_character: @current_character)

    result = call_service(event)

    assert_equal event.body, result[:body]
  end

  test 'parse private talk event to the other character' do
    character = create(:character, gender: 'K')
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: @current_character,
                           receiver_character: character)

    result = call_service(event)

    assert_equal event.body, result[:body]
  end

  test 'parse event body with <!--CHARID--> placeholder' do
    character = create(:character, gender: 'K')
    body = "You can see new person: <!--CHARID:#{character.id}-->"
    event = create(:event, body: body, location: @location, character: nil,
                           receiver_character: nil)

    result = call_service(event)

    expected_body = 'You can see new person: '\
                    "#{expected_character_link(character.id)}"
    assert_equal expected_body, result[:body]
    assert_nil result[:lead]
  end

  test 'parse event body with <!--CHARID--> and <!--LOCID--> placeholders' do
    character = create(:character, gender: 'K')
    location = create(:location)
    body = 'You can see that '\
           "<!--CHARID:#{character.id}-->"\
           ' is entering: '\
           "<!--LOCID:#{location.id}-->"
    event = create(:event, body: body, location: @location, character: nil,
                           receiver_character: nil)

    result = call_service(event)

    expected_body =
      'You can see that ' \
      "#{expected_character_link(character.id)}" \
      ' is entering: ' \
      "<a href=\"/locations/#{location.id}/name\">unnamed place</a>"
    assert_equal expected_body, result[:body]
    assert_nil result[:lead]
  end

  test 'parse event body with multiple <!--CHARID--> and <!--LOCID--> placeholders' do
    character1 = create(:character, gender: 'K')
    character2 = create(:character, gender: 'M')
    location = create(:location)
    building = create(:location, :building, name: 'Building')
    body = 'You see '\
           "<!--CHARID:#{character1.id}--> and "\
           "<!--CHARID:#{character2.id}-->"\
           ' are going from '\
           "<!--LOCID:#{location.id}-->"\
           ' into: '\
           "<!--LOCID:#{building.id}-->"
    event = create(:event, body: body, location: @location, character: nil,
                           receiver_character: nil)

    result = call_service(event)

    expected_body =
      'You see ' \
      "#{expected_character_link(character1.id)} and " \
      "#{expected_character_link(character2.id, 'man')}" \
      ' are going from '\
      "<a href=\"/locations/#{location.id}/name\">unnamed place</a>" \
      ' into: ' \
      "<a href=\"/locations/#{building.id}/name\">Building</a>"
    assert_equal expected_body, result[:body]
    assert_nil result[:lead]
  end
end

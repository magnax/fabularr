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
    assert_equal 'events.character.talking.other', result[:lead][:key]
    assert_equal "<a href=\"/characters/#{character.id}/name\">unknown man</a>", result[:lead][:char_name]
  end

  test 'parse talk event from the same character' do
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: @current_character)

    result = call_service(event)

    assert_equal event.body, result[:body]
    assert_equal 'events.character.talking.me', result[:lead][:key]
  end

  test 'parse private talk event from the other character' do
    character = create(:character, gender: 'K')
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: character,
                           receiver_character: @current_character)

    result = call_service(event)

    assert_equal event.body, result[:body]
    assert_equal 'events.character.talking.to_me', result[:lead][:key]
    assert_equal "<a href=\"/characters/#{character.id}/name\">unknown woman</a>", result[:lead][:char_name]
  end

  test 'parse private talk event to the other character' do
    character = create(:character, gender: 'K')
    event = create(:event, body: Faker::Lorem.sentence,
                           location: @location, character: @current_character,
                           receiver_character: character)

    result = call_service(event)

    assert_equal event.body, result[:body]
    assert_equal 'events.character.talking.to_other', result[:lead][:key]
    assert_equal "<a href=\"/characters/#{character.id}/name\">unknown woman</a>", result[:lead][:char_name]
  end

  test 'parse event body with <!--CHARID--> placeholder' do
    character = create(:character, gender: 'K')
    body = "You can see new person: <!--CHARID:#{character.id}-->"
    event = create(:event, body: body, location: @location, character: nil,
                           receiver_character: nil)

    result = call_service(event)

    expected_body = "You can see new person: <a href=\"/characters/#{character.id}/name\">unknown woman</a>"
    assert_equal expected_body, result[:body]
    assert_nil result[:lead]
  end
end

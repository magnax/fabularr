# frozen_string_literal: true

require 'test_helper'

class ApplicationCableCharacterChannelTest < ActionCable::Channel::TestCase
  tests CharacterChannel

  test 'channel' do
    character = create(:character)

    stub_connection(current_user: character.user)
    subscribe(character_id: character.id)

    assert subscription.confirmed?
    assert_has_stream "char_#{character.id}"
  end
end

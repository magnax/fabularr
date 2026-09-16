# frozen_string_literal: true

require 'test_helper'

class CharactersTalkServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(char_id)
    Characters::TalkService.call(@character, char_id)
  end

  test 'raise error when invalid character' do
    assert_raise Characters::InvalidCharacterError do
      call_service(0)
    end
  end
end

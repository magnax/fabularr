# frozen_string_literal: true

require 'test_helper'

class CharactersNewTest < ApplicationSystemTest
  def setup
    @user = create(:user)
    sign_in
  end

  test 'visiting the characters list page' do
    visit list_url
    click_on 'Create new character'

    assert_current_path new_character_path(locale: 'en')
    assert_selector 'h1', text: 'New character'
  end
end

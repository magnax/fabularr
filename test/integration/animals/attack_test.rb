# frozen_string_literal: true

require 'test_helper'

class AnimalsAttackTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user)
    sign_in
    click_link 'Magnus'
  end

  test 'shows attack info page' do
    visit '/en/animals/attack'

    assert_equal 200, page.status_code
    assert_content 'Hunting'
  end
end

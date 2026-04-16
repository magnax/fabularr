# frozen_string_literal: true

require 'test_helper'

class TravellersNewTest < ActionDispatch::IntegrationTest
  def setup
    @user = create(:user)
    @character = create(:character, name: 'Magnus', user: @user,
                                    location: nil, coords: { x: 100, y: 100 })
  end

  test 'travellers info' do
    traveller = create(:traveller, subject: @character)
    sign_in(@user)
    click_link 'Magnus'

    assert_content 'Travelling from unnamed place'
    assert_link 'Stop', href: "#{host}/en/travellers/#{traveller.id}/stop"
    assert_link 'Reverse', href: "#{host}/en/travellers/#{traveller.id}/reverse"
  end
end

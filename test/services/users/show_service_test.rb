# frozen_string_literal: true

require 'test_helper'

class UsersShowServiceTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
  end

  def call_service
    Users::ShowService.call(@user)
  end

  test 'hunger levels' do
    char_full = create(:character, user: @user, hunger: 49)
    char_hungry = create(:character, user: @user, hunger: 51)
    char_skinny = create(:character, user: @user, hunger: 80)
    char_agony = create(:character, user: @user, hunger: 91)

    res = call_service

    chars = res[:characters]
    assert_nil chars.find { |c| c['id'] == char_full.id }['hunger_level']
    assert_equal 'hungry', chars.find { |c| c['id'] == char_hungry.id }['hunger_level']
    assert_equal 'skinny', chars.find { |c| c['id'] == char_skinny.id }['hunger_level']
    assert_equal 'agony', chars.find { |c| c['id'] == char_agony.id }['hunger_level']
  end

  test 'damage levels' do
    char_healthy = create(:character, user: @user, damage: 49)
    char_scratch = create(:character, user: @user, damage: 51)
    char_wounded = create(:character, user: @user, damage: 80)
    char_agony = create(:character, user: @user, damage: 91)

    res = call_service

    chars = res[:characters]
    assert_nil chars.find { |c| c['id'] == char_healthy.id }['damage_level']
    assert_equal 'scratch', chars.find { |c| c['id'] == char_scratch.id }['damage_level']
    assert_equal 'wounded', chars.find { |c| c['id'] == char_wounded.id }['damage_level']
    assert_equal 'agony', chars.find { |c| c['id'] == char_agony.id }['damage_level']
  end

  test 'show number of unread events' do
    char_1 = create(:character, user: @user)
    char_2 = create(:character, user: @user)

    create(:event, receiver_character: char_1)

    res = call_service

    ch = res[:characters].find { |c| c['id'] == char_1.id }
    assert_equal 1, ch[:unread_events]

    ch = res[:characters].find { |c| c['id'] == char_2.id }
    assert_equal 0, ch[:unread_events]
  end
end

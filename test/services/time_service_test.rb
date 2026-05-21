# frozen_string_literal: true

require 'test_helper'

class TimeServiceTest < ActiveSupport::TestCase
  def teardown
    I18n.locale = 'en'
  end

  test '#display_time - hours (en)' do
    assert_equal '1 hour', TimeService.display_time(7200)
    assert_equal '1 hour', TimeService.display_time(5500)
    assert_equal '2 hours', TimeService.display_time(14_400)
    assert_equal '2 hours', TimeService.display_time(12_800)
    assert_equal '1 hour', TimeService.display_time(9_800)
    assert_equal '3 hours', TimeService.display_time(20_000)
    assert_equal '5 hours', TimeService.display_time(5 * 7200)
  end

  test '#display_time - hours (pl)' do
    I18n.locale = 'pl'

    assert_equal '1 godzina', TimeService.display_time(7200)
    assert_equal '1 godzina', TimeService.display_time(5500)
    assert_equal '2 godziny', TimeService.display_time(14_400)
    assert_equal '2 godziny', TimeService.display_time(12_800)
    assert_equal '1 godzina', TimeService.display_time(9_800)
    assert_equal '3 godziny', TimeService.display_time(20_000)
    assert_equal '5 godzin', TimeService.display_time(5 * 7200)
    assert_equal '11 godzin', TimeService.display_time(11 * 7200)
  end

  test '#display_time - days (pl)' do
    I18n.locale = 'pl'

    assert_equal '1 dzień', TimeService.display_time(24 * 3600)
    assert_equal '1.25 dnia', TimeService.display_time(13 * 7200)
    assert_equal '1.25 dnia', TimeService.display_time(15 * 7200)
    assert_equal '2 dni', TimeService.display_time(24 * 7200)
    assert_equal '2.5 dnia', TimeService.display_time(30 * 7200)
    assert_equal '2.75 dnia', TimeService.display_time(31 * 7200)
    assert_equal '1.75 dnia', TimeService.display_time(21 * 7200)
  end
end

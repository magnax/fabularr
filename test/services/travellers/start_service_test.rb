# frozen_string_literal: true

require 'test_helper'

class TravellersStartServiceTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_service(params)
    Travellers::StartService.call(@character, params)
  end

  test 'create new traveller record' do
    params = {
      direction: 90
    }

    assert_difference -> { Traveller.count } => 1 do
      call_service(params)
    end

    t = Traveller.last
    assert_equal @character, t.subject
    assert_equal params[:direction], t.direction

    assert_equal 1, Traveller.active.count
  end
end

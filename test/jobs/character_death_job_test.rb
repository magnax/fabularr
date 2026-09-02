# frozen_string_literal: true

require 'test_helper'

class CharacterDeathJobTest < ActiveSupport::TestCase
  def setup
    @character = create(:character)
  end

  def call_job
    CharacterDeathJob.perform_sync(@character.id)
  end

  test "update character's status and weight" do
    assert @character.status
    assert_nil @character.weight

    call_job

    assert_not @character.reload.status
    assert_equal Character::WEIGHT, @character.weight
  end

  test 'schedule next run' do
    Sidekiq.testing!(:fake) do
      call_job
      assert_equal 1, CharacterDeathJob.jobs.size
    end
  end
end

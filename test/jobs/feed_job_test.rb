# frozen_string_literal: true

require 'test_helper'

class FeedJobTest < ActiveSupport::TestCase
  def call_job
    FeedJob.perform_sync
  end

  test "update character's hunger" do
    character = create(:character)

    Sidekiq.testing!(:fake) do
      call_job
    end

    assert_equal 5, character.reload.hunger
  end

  test 'call death service if character hunger above 100' do
    character = create(:character, hunger: 99)

    Sidekiq.testing!(:fake) do
      assert_difference -> { CharacterDeathJob.jobs.size } => 1 do
        call_job
      end
    end

    assert_equal 100, character.reload.hunger
  end

  test 'schedule next run' do
    Sidekiq.testing!(:fake) do
      assert_difference -> { FeedJob.jobs.size } => 1 do
        call_job
      end
    end
  end
end

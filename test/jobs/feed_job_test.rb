# frozen_string_literal: true

require 'test_helper'

class FeedJobTest < ActiveSupport::TestCase
  def call_job
    FeedJob.perform_sync
  end

  test "update character's hunger" do
    character = create(:character)

    call_job

    assert_equal 5, character.reload.hunger
  end

  test 'schedule next run' do
    Sidekiq.testing!(:fake) do
      call_job
      assert_equal 1, FeedJob.jobs.size
    end
  end
end

require 'test_helper'

class TravellersUpdateJobTest < ActiveSupport::TestCase
  def call_job
    TravellersUpdateJob.perform_sync
  end

  test 'update position' do
    time = DateTime.parse('2026-04-11 09:00')
    character = create(:character, coords: { x: 200, y: 300 })
    create(:traveller, subject: character,
                       direction: 135, speed: 100, checked_at: time)

    Timecop.travel(time + 1.hour)
    call_job

    assert_equal 202.2, character.reload.x.round(1)
    assert_equal 302.2, character.y.round(1)
    Timecop.unfreeze
  end

  test 'schedule next run' do
    create(:setting, key: 'travels', value: '1')

    Sidekiq.testing!(:fake) do
      call_job
      assert_equal 1, TravellersUpdateJob.jobs.size
    end
  end
end

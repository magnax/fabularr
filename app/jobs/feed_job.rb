# frozen_string_literal: true

class FeedJob
  include Sidekiq::Job

  def perform
    Character.all.find_each do |character|
      Characters::FeedService.call(character.id)
    end

    tomorrow = DateTime.parse("#{Date.current + 1.day} 13:00")
    ::FeedJob.perform_at(tomorrow)
  end
end

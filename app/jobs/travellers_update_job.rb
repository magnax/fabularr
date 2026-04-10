# frozen_string_literal: true

class TravellersUpdateJob
  include Sidekiq::Job

  def perform
    Traveller.active.find_each do |traveller|
      Travellers::UpdatePositionService.call(traveller)
    end

    s = Setting.find_by key: 'travels'
    return unless s&.value == '1'

    ::TravellersUpdateJob.perform_in 5.minutes
  end
end

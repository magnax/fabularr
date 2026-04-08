# frozen_string_literal: true

namespace :travels do
  desc 'Start job'
  task start: :environment do
    Setting.setup('travels')

    TravellersUpdateJob.perform_async
  end

  desc 'Start job just once'
  task start_once: :environment do
    Setting.setup('travels', '0')

    TravellersUpdateJob.perform_async
  end

  desc 'Stop job'
  task stop: :environment do
    Setting.setup('travels', '0')
  end

  desc 'Check job status'
  task status: :environment do
    s = Setting.where(key: 'travels').first&.value
    puts "Travels job status: #{s}"
  end
end

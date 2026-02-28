# frozen_string_literal: true

namespace :jobs do
  desc 'Start job'
  task start: :environment do
    s = Setting.where(key: 'projects').first_or_create
    s.update(value: '1')

    ProjectsProgressJob.perform_async
  end

  desc 'Start job just once'
  task start_once: :environment do
    s = Setting.where(key: 'projects').first_or_create
    s.update(value: '0')

    ProjectsProgressJob.perform_async
  end

  desc 'Stop job'
  task stop: :environment do
    s = Setting.where(key: 'projects').first_or_create
    s.update(value: '0')
  end

  desc 'Check job status'
  task status: :environment do
    s = Setting.where(key: 'projects').first&.value
    puts "Job status: #{s}"
  end
end

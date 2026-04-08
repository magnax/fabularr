# frozen_string_literal: true

namespace :jobs do
  desc 'Start job'
  task start: :environment do
    Setting.setup('projects')

    ProjectsProgressJob.perform_async
  end

  desc 'Start job just once'
  task start_once: :environment do
    Setting.setup('projects', '0')

    ProjectsProgressJob.perform_async
  end

  desc 'Stop job'
  task stop: :environment do
    Setting.setup('projects', '0')
  end

  desc 'Check job status'
  task status: :environment do
    s = Setting.where(key: 'projects').first&.value
    puts "Job status: #{s}"
  end
end

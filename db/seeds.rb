# frozen_string_literal: true

Rails.application.configure do
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.log_level = :debug
end

require_relative 'seeds/project_types'
require_relative 'seeds/item_types'
require_relative 'seeds/settings'
require_relative 'seeds/locations'
require_relative 'seeds/resources'
require_relative 'seeds/recipes'

User.create!(email: 'm@m.eu', password: 'fabular', password_confirmation: 'fabular')

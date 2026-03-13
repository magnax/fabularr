# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Fabularr
  class Application < Rails::Application
    config.i18n.load_path += Dir[Rails.root.join('my/locales/*.{rb,yml}').to_s]
    I18n.available_locales = %i[ca en pl]
    config.i18n.default_locale = :pl

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: true,
                       request_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
    config.load_defaults 7.0
  end

  Faker::Config.locale = :ca unless Rails.env.production?
end

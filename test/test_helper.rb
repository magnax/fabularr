# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/minitest'
require 'capybara/minitest'
require 'capybara/rails'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def host
    @host ||= Capybara.app_host
  end
end

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    parallelize(workers: :number_of_processors)

    ActiveRecord::Migration.check_all_pending!

    fixtures :all

    DatabaseCleaner.strategy = :transaction

    def login(character = nil)
      ApplicationController.any_instance.expects(:require_authentication).returns(true)
      return if character.blank?

      ApplicationController.any_instance
                           .expects(:current_character)
                           .times(1..10)
                           .returns(character)
    end
  end
end

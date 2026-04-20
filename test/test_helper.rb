# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
if ENV['COVERAGE'] == '1'
  require 'simplecov'
  SimpleCov.start 'rails'
end

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

  parallelize(workers: :number_of_processors) unless ENV['COVERAGE'] == '1'

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def host
    @host ||= Capybara.default_host
  end

  def sign_in(user)
    visit new_session_url
    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Login'
  end
end

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    parallelize(workers: :number_of_processors) unless ENV['COVERAGE'] == '1'

    ActiveRecord::Migration.check_all_pending!

    fixtures :all

    DatabaseCleaner.strategy = :transaction

    def login(user, character = nil)
      ApplicationController.any_instance
                           .expects(:require_authentication)
                           .returns(true)
      if character.blank?
        ApplicationController.any_instance
                             .expects(:current_user)
                             .times(1..10)
                             .returns(user || create(:user))
      else

        ApplicationController.any_instance
                             .expects(:current_character)
                             .times(1..10)
                             .returns(character)
      end
    end
  end
end

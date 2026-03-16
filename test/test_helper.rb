# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/minitest'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods

    ActiveRecord::Migration.check_all_pending!

    fixtures :all

    DatabaseCleaner.strategy = :transaction

    def login(user, character)
      ApplicationController.any_instance.expects(:current_user).returns(user)
      ApplicationController.any_instance.expects(:current_character).returns(character)
    end
  end
end

class ApplicationSystemTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
end

# class Minitest::Spec
#   before :each do
#     DatabaseCleaner.start
#   end

#   after :each do
#     DatabaseCleaner.clean
#   end
# end

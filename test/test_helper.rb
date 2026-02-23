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

    def login(user, character)
      ApplicationController.any_instance.expects(:current_user).returns(user)
      ApplicationController.any_instance.expects(:current_character).returns(character)
    end
  end
end

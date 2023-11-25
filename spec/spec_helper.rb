# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

unless ENV['NOCOVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true

  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  config.order = "random"
  
  config.include Capybara::DSL
  config.include FactoryBot::Syntax::Methods

  # [:controller, :view, :request].each do |type|
  #   config.include ::Rails::Controller::Testing::TestProcess, type: type
  #   config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
  #   config.include ::Rails::Controller::Testing::Integration, type: type
  # end
end

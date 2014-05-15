ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def route_point_params(num_points, point_attrs = {})
    points = []
    num_points.times do
      new_point = {
        lat: rand * 90,
        long: rand * 180,
        altitude: rand * 500,
        time: Time.now,
        kph: rand * 500
      }
      new_point.merge!(point_attrs)
      points << new_point
    end
    points
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require "minitest/reporters"
reports_dir = ENV["CI_REPORTS"] || "test/results"
Minitest::Reporters.use! [MiniTest::Reporters::DefaultReporter.new,
                          MiniTest::Reporters::JUnitReporter.new(reports_dir, true)]

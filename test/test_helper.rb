ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include ActionDispatch::TestProcess
require 'sidekiq/testing'
Sidekiq::Testing.fake!

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

    # Ensure route is long enough (Route.meets_distance_requirements)
    unless point_attrs[:lat]
      points.first[:lat] = 4
      points.last[:lat] = -4
    end

    points
  end
end

require 'mocha/mini_test'

module Devise
  module TestHelpers
    def sign_in(user)
      token = mock()
      token.stubs(:accessible?).returns(true)
      token.stubs(:acceptable?).returns(true)
      token.stubs(:resource_owner_id).returns(user.id)
      @controller.stubs(:doorkeeper_token).returns(token)
    end

    def sign_out(user)
      @controller.stubs(:doorkeeper_token).returns(nil)
    end
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end


require "minitest/reporters"
reports_dir = ENV["CI_REPORTS"] || "test/results"
Minitest::Reporters.use! [MiniTest::Reporters::DefaultReporter.new,
                          MiniTest::Reporters::JUnitReporter.new(reports_dir, true)]

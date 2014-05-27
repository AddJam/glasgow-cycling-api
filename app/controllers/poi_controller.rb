require 'points_extractor'

class PoiController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def all
    extractor = PointsExtractor.new
    render json: {
      locations: extractor.extract_all_types
    }
  end
end

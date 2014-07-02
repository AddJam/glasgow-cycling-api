require 'points_extractor'

class PoiController < ApplicationController
  def all
    extractor = PointsExtractor.new
    render json: {
      locations: extractor.extract_all_types
    }
  end
end

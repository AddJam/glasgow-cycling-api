class PoiController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  def all
    render json: {locations: [{
        name: "banana",
        lat: 55.858,
        long: -4.292,
        type: "rack"
      }]}
  end
end

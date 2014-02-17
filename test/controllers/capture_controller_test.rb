require 'test_helper'

class CaptureControllerTest < ActionController::TestCase
  test "should get route" do
    get :route
    assert_response :success
  end

  test "should get review" do
    get :review
    assert_response :success
  end

end

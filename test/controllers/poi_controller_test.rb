require 'test_helper'

class PoiControllerTest < ActionController::TestCase
  test "should get all" do
    user = create(:user)
    sign_in user
    get :all
    assert_response :success
  end
end

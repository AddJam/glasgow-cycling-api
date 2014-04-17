require 'test_helper'

class FlaggingTest < ActiveSupport::TestCase
  def setup
    user = create(:user)
    route = create_list(:route, 2)
  end

  test "user can flag many routes" do
    user = User.last
    first_route = Route.all[0]
    second_route = Route.all[1]

    first_route.flaggers << user
    first_route.save

    second_route.flaggers << user
    second_route.save

    assert first_route.flaggers.include?(user), "user should be a flagger of route one"
    assert second_route.flaggers.include?(user), "user should be a flagger of route two"

    assert user.flagged_routes.include?(first_route), "user should have flagged route"
    assert user.flagged_routes.include?(second_route), "user should have flagged route"
  end
end

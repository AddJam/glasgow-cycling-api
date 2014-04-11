require 'test_helper'

class RouteReviewTest < ActiveSupport::TestCase
 test "a review should store correctly" do
  	user_review = {
				safety_rating: 1,
				environment_rating: 1,
				difficulty_rating: 1,
				comment: "A review comment"
			}

    user = create(:user)
  	route = create(:route)

  	review = route.create_review(user, user_review)
  assert_not_nil review, "review created by review method"

    route = Route.where(id: route.id).first
    assert_not_nil route.review, "review should be associated with route"
    assert user.reviews.include?(review), "user should contain the new review"
  end

  test "an incomplete review should not store" do
  	user_review = {
				environment_rating: 1.43,
				difficulty_rating: 1,
				comment: 34
  	}

  	route = create(:route)

  	review = route.create_review(create(:user), user_review)
  	assert_nil review, "review not created by record"

    route = Route.where(id: route.id).first
    assert_nil route.review, "review should not be associated with route"
	end
end

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
  	initial_reviews = route.reviews.count

  	review = route.review(user, user_review)
  	new_reviews = route.reviews.count

  	assert_not_nil review, "review created by review method"
    assert_equal initial_reviews + 1, new_reviews, "review count increased by 1"
    assert route.reviews.include?(review), "route should contain the review"
    assert user.reviews.include?(review), "user should contain the new review"
  end

  test "an incomplete review should not store" do
  	user_review = {
				environment_rating: 1.43,
				difficulty_rating: 1,
				comment: 34
  	}

  	route = create(:route)
  	initial_reviews = route.reviews.count

  	review = route.review(create(:user), user_review)
  	new_reviews = route.reviews.count

  	assert_nil review, "review not created by record"
    assert_equal initial_reviews, new_reviews, "review count not increased"
	end
end

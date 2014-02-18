require 'test_helper'

class RouteReviewTest < ActiveSupport::TestCase
 test "a review should store correctly" do
  	user_review = {
				safety_rating: 1,
				environment_rating: 1,
				difficulty_rating: 1,
				comment: "A review comment"
			}

  	route = Route.first
  	initial_reviews = route.reviews.count

  	review = route.review(user_review)
  	new_reviews = route.reviews.count

  	assert_not_nil review, "Review created by record"
    assert_equal initial_reviews + 1, new_reviews, "Review count increased by 1"
  end

  test "a bad review should not store" do
  	user_review = {
				environment_rating: 1.43,
				difficulty_rating: 1,
				comment: 34
  	}

  	route = Route.first
  	initial_reviews = route.reviews.count

  	review = route.review(user_review)
  	new_reviews = route.reviews.count

  	assert_nil review, "Review not created by record"
    assert_equal initial_reviews, new_reviews, "Review count not increased"
	end
end

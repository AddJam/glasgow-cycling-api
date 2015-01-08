# == Schema Information
#
# Table name: route_reviews
#
#  id         :integer          not null, primary key
#  route_id   :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  rating     :integer
#

require 'test_helper'

class RouteReviewTest < ActiveSupport::TestCase
 test "a review should store correctly" do
		rating = 5

    user = create(:user)
  	route = create(:route)

  	review = route.create_review(user, rating)
    assert_not_nil review, "review created by review method"

    route = Route.where(id: route.id).first
    assert_not_nil route.review, "review should be associated with route"
    assert user.reviews.include?(review), "user should contain the new review"
  end

  test "rating should be a mandatory part of review" do
  	route = create(:route)

  	review = route.create_review(create(:user), nil)
  	assert_nil review, "review not created by record"

    route = Route.where(id: route.id).first
    assert_nil route.review, "review should not be associated with route"
	end
end

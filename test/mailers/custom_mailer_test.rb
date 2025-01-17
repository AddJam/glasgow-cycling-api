require 'test_helper'

class CustomMailerTest < ActionMailer::TestCase
  test "reset_password_instructions" do
  	user = create(:user)
    mail = CustomMailer.reset_password_instructions(user, nil)
    assert_equal "Reset password instructions", mail.subject, "custom reset password, subject not set"
    assert mail.to.include?(user.email), "user email not as expected"
  end
end

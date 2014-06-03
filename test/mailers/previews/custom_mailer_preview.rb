# Preview all emails at http://localhost:3000/rails/mailers/custom_mailer
class CustomMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/custom_mailer/reset_password_instructions
  def reset_password_instructions
    CustomMailer.reset_password_instructions(User.first, User.first.authentication_token)
  end

  # Preview this email at http://localhost:3000/rails/mailers/custom_mailer/unlock_instructions
  def unlock_instructions
  	CustomMailer.unlock_instructions
  end

  # Preview this email at http://localhost:3000/rails/mailers/custom_mailer/confirmation_instructions
  def confirmation_instructions
  	CustomMailer.confirmation_instructions
  end

end

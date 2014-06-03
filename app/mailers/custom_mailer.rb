class CustomMailer < Devise::Mailer
  default from: "from@example.com"
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.custom_mailer.reset_password_instructions.subject
  #
  def reset_password_instructions(record, opts={})
  	opts[:content_type] = "text/html";
  	devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions
  	@greeting = "Hi"

  	mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.custom_mailer.confirmation_instructions.subject
  #
  def confirmation_instructions
  	@greeting = "Hi"

  	mail to: "to@example.org"
  end
end

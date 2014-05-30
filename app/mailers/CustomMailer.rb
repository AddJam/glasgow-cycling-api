class CustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def reset_password_instructions(record, token, opts={})
  	@token = token
  	devise_mail(record, :reset_password_instructions, opts)
  end
end

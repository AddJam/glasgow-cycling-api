class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  private

  def current_user
    if doorkeeper_token
      return current_resource_owner
    end
    # fallback to auth with warden if no doorkeeper token
    warden.authenticate(:scope => :user)
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end

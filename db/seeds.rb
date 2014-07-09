# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Development env configuration
if Rails.env.development?
	# Add cycling app
	p "Adding cycling application"
	app = Doorkeeper::Application.create name: "Cycling", redirect_uri: "urn:ietf:wg:oauth:2.0:oob", uid: "123", secret: "321"
	p "client_id: #{app.uid}"
	p "client_secret: #{app.secret}"

	# Add test user
	User.create(first_name: "John", last_name: "Smith", email: "test@user.com", password: "password")
	p "Added test user"
end
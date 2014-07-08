# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

if Rails.env.development?
	p "Adding cycling application"
	app = Doorkeeper::Application.create name: "Cycling", redirect_uri: "urn:ietf:wg:oauth:2.0:oob", uid: "123", secret: "321"
	p "client_id: #{app.uid}"
	p "client_secret: #{app.secret}"
end
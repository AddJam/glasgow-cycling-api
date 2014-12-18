Ember.Handlebars.helper 'format-time', (seconds, options)->
	totalHours = Math.round(seconds / 3600)
	days = Math.floor(totalHours / 24)
	hours = Math.round(totalHours % 24)

	if days == 1
		dayDescriptor = "day"
	else
		dayDescriptor = "days"

	if hours == 1
		hourDescriptor = "hour"
	else
		hourDescriptor = "hours"

	html = "#{days}<span class='small'>#{dayDescriptor}</span> #{hours}<span class='small'>#{hourDescriptor}</span>"
	return new Ember.Handlebars.SafeString(html)
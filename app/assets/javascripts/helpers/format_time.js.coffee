Ember.Handlebars.helper 'format-time', (seconds, options)->
	totalHours = Math.round(seconds / 3600)
	days = Math.floor(totalHours / 24)
	hours = Math.round(totalHours % 24)
	minutes = Math.round((seconds - (hours * 3600)) / 60)

	if days == 1
		dayDescriptor = "day"
	else
		dayDescriptor = "days"

	if hours == 1
		hourDescriptor = "hour"
	else
		hourDescriptor = "hours"

	if minutes == 1
		minuteDescriptor = "minute"
	else
		minuteDescriptor = "minutes"

	html = ""

	if days > 0
		html += "#{days}<span class='small'>#{dayDescriptor}</span>"

	if hours > 0
		html += " #{hours}<span class='small'>#{hourDescriptor}</span>"

	if minutes > 0 && days == 0
		html += " #{minutes}<span class='small'>#{minuteDescriptor}</span>"

	if days == 0 && hours == 0 && minutes == 0
		html = "No Activity"

	return new Ember.Handlebars.SafeString(html.trim())
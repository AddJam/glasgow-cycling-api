Ember.Handlebars.helper 'format-time', (seconds, options)->
	totalHours = Math.round(seconds / 3600)
	days = Math.floor(totalHours / 24)
	hours = Math.round(totalHours % 24)
	html = "#{days}<span class='small'>days</span> #{hours}<span class='small'>hours</span>"
	return new Ember.Handlebars.SafeString(html)
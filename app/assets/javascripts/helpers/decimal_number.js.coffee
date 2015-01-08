Ember.Handlebars.helper 'decimal-number', (value, options)->
	Math.round(value * 100) / 100
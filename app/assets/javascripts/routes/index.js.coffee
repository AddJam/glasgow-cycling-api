JourneyAPI.IndexRoute = Ember.Route.extend {
	model: ->
		Ember.RSVP.hash({
			now: this.store.find('overview', {
				period: 'day',
				filter: 'now'
			}).then((overviews)->
				overviews.get('firstObject')
			),
			last: this.store.find('overview', {
				period: 'day',
				filter: 'last'
			}).then((overviews)->
				overviews.get('firstObject')
			),
			average: this.store.find('overview', {
				period: 'day',
				filter: 'average'
			}).then((overviews)->
				overviews.get('firstObject')
			)
		})
}
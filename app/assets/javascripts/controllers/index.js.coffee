JourneyAPI.IndexController = Ember.ObjectController.extend({
	percentageToMoon: (->
		totalDistance = @get('now.totalDistance')
		if totalDistance
			((totalDistance / 384400) * 100).toFixed(1)
		else
			0
	).property('now.totalDistance')
})
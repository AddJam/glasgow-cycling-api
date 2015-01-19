JourneyAPI.IndexController = Ember.ObjectController.extend({
	segments: []
	routes: []
	distances: []

	setSegments: (->
		@segments = @model.now.get('segments').content
		@routes = @segments.map (s)->
			s.get('routes')
		@distances = @segments.map (s)->
			s.get('distance')
	).observes('model')


	percentageToMoon: (->
		totalDistance = @get('now.totalDistance')
		if totalDistance
			((totalDistance / 384400) * 100).toFixed(1)
		else
			0
	).property('now.totalDistance')

	animateMoonRider: (->
		setTimeout(()=>
			$('.cyclist').animate({
				left: "#{@get('percentageToMoon')}%"
			})
		, 0)
	).observes('percentageToMoon', 'now.totalDistance')
})
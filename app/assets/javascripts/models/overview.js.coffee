JourneyAPI.Overview = DS.Model.extend {
	totalCyclists: DS.attr('number')
	activeCyclists: DS.attr('number')
	newCyclists: DS.attr('number')
	distance: DS.attr('number')
	totalDistance: DS.attr('number')
	duration: DS.attr('number')
	routes: DS.attr('number')
	longestRoute: DS.attr('number')
	avgDistancePerUser: DS.attr('number')
	avgDistancePerRoute: DS.attr('number')
	segments: DS.hasMany('segment')

	routeSegments: (->
		@segments.map (s)->
			s.get('routes')
	).property('segments.@each')
	
	distanceSegments: (->
		@segments.map (s)->
			s.get('distance')
	).property('segments.@each')
}

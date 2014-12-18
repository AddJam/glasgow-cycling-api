JourneyAPI.Overview = DS.Model.extend {
	cyclists: DS.attr('number')
	newCyclists: DS.attr('number')
	distance: DS.attr('number')
	seconds: DS.attr('number')
	routes: DS.attr('number')
	longestRoute: DS.attr('number')
	furthestRoute: DS.attr('number')
	avgDistancePerUser: DS.attr('number')
	avgDistancePerRoute: DS.attr('number')
}

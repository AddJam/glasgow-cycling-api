JourneyAPI.LineChartComponent = Ember.Component.extend({
  setup: (->
    data = {
      labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      series: [
        [5, 2, 4, 2, 0]
      ]
    }
    new Chartist.Line("##{this.elementId} .ct-chart", data)
  ).on('didInsertElement')
})
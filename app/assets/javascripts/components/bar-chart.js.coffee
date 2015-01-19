JourneyAPI.BarChartComponent = Ember.Component.extend({
  segments: []

  setup: (->
    data = {
      labels: ['midnight', '6am', 'noon', '6pm', 'midnight'],
      series: [@get('segments')]
    }
    opts = {
      axisX: {
        showGrid: false
      }
    }
    new Chartist.Bar("##{this.elementId} .ct-chart", data, opts)
  ).on('didInsertElement')
})
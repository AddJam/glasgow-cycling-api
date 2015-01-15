JourneyAPI.BarChartComponent = Ember.Component.extend({
  setup: (->
    data = {
      labels: ['6am', '9am', 'noon', '3pm', '6pm', '9pm'],
      series: [
        [5, 2, 4, 2, 0, 0]
      ]
    }
    opts = {
      axisX: {
        showGrid: false
      }
    }
    new Chartist.Bar("##{this.elementId} .ct-chart", data, opts)
  ).on('didInsertElement')
})
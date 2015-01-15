JourneyAPI.LineChartComponent = Ember.Component.extend({
  setup: (->
    data = {
      labels: ['6am', '9am', 'noon', '3pm', '6pm', '9pm'],
      series: [
        [5, 2, 4, 2, 2, 0]
      ]
    }
    opts = {
      axisY: {
        showGrid: false
        labelInterpolationFnc: (value)->
          value + ' km'
      }
    }
    new Chartist.Line("##{this.elementId} .ct-chart", data, opts)
  ).on('didInsertElement')
})
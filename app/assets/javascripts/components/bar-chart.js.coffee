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
      },
      axisY: {
        labelInterpolationFnc: (value)->
          if (value % 1) == 0
            value
          else
            null
      }
    }
    new Chartist.Bar("##{this.elementId} .ct-chart", data, opts)
  ).on('didInsertElement')
})
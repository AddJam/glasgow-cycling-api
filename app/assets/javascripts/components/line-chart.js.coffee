JourneyAPI.LineChartComponent = Ember.Component.extend({
  setup: (->
    data = {
      labels: ['midnight', '6am', 'noon', '6pm', 'midnight'],
      series: [@get('segments')]
    }
    opts = {
      axisX: {
        showGrid: false
      }
      axisY: {
        showGrid: true
        labelInterpolationFnc: (value)->
          if (value % 1) == 0
            value + ' km'
          else
            null
      }
    }
    new Chartist.Line("##{this.elementId} .ct-chart", data, opts)
  ).on('didInsertElement')

  changed: (->
    console.log('segments changed');
  ).observes('segments.[]')
})
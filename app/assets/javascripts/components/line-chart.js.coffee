JourneyAPI.LineChartComponent = Ember.Component.extend({
  setup: (->
    console.log('setup')
    data = {
      labels: ['midnight', '6am', 'noon', '6pm', 'midnight'],
      series: [@get('segments')]
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

  changed: (->
    console.log('segments changed');
  ).observes('segments.[]')
})
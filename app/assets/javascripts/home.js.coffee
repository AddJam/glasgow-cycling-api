# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.test-button').click ->
    endpointDiv = $(this).parent().parent()
    testOutputDiv = endpointDiv.find('.test-output')

    buttonIsHide = ->
      testOutputDiv.is(":visible")

    toggleButton = =>
      if $(this).html().indexOf('hide')
        $(this).html('hide')
      else
        $(this).html('test')

    if buttonIsHide()
      testOutputDiv.slideUp()
      toggleButton();
      return
    else
      testOutputDiv.slideDown()
      toggleButton();
      

    showOutput = (text) =>
      testOutputDiv.html(text)

    showOutput("Making request...")
    requestType = $(this).data('request-type')
    requestUrl = document.location.href + $(this).data('request-url')
    $.ajax({
      type: requestType,
      url: requestUrl,
      success: (data) ->
        output = "<p><span class='url-title'>URL:</span><span class='url'>#{requestUrl}</span></p>"
        output += "<pre>#{JSON.stringify(data, undefined, 2)}</pre>"
        showOutput(output)
      error: (data) ->
        showOutput("Request Error")
    })

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
      

    showOutput = (url, text) =>
      if url
        text = "<p><span class='url-title'>URL:</span><span class='url'>#{url}</span></p>" + text
      testOutputDiv.html(text)

    output = $(this).data('request-output')
    requestUrl = document.location.href + $(this).data('request-url')
    if output
      output = $.parseJSON(decodeURI(output))
      output = JSON.stringify(output, undefined, 2)
      showOutput(requestUrl, "<pre>#{output}</pre>")
    else
      showOutput(null, "Making request...")
      requestType = $(this).data('request-type')
      $.ajax({
        type: requestType,
        url: requestUrl,
        success: (data) ->
          output = "<pre>#{JSON.stringify(data, undefined, 2)}</pre>"
          showOutput(requestUrl, output)
        error: (data) ->
          showOutput(requestUrl, "Request Error")
      })

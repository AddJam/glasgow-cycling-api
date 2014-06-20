# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.test-button').click ->
    $('.test-output').html("Making request...");
    requestType = $(this).data('request-type')
    requestUrl = document.location.href + $(this).data('request-url');
    $.ajax({
      type: requestType,
      url: requestUrl,
      success: (data) ->
        $('.test-output').html("Request Success");
      error: (data) ->
        $('.test-output').html("Request Error");
    })
    $('.test-output').fadeIn();
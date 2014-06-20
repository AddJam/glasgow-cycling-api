# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.test-button').click ->
    showOutput = (text) =>
      $(_this).parent().parent().find('.test-output').html(text);

    showOutput("Making request...");
    requestType = $(this).data('request-type')
    requestUrl = document.location.href + $(this).data('request-url');
    $.ajax({
      type: requestType,
      url: requestUrl,
      success: (data) ->
        showOutput("Request Success");
      error: (data) ->
        showOutput("Request Error");
    })
    $('.test-output').fadeIn();
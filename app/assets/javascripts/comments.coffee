# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.new-comment-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    owner = $(this).data('owner')
    $("##{owner} .new-comment-form").show()

# TODO: zebra tables comments

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
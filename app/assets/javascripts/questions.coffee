# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question-form').show()

  # Subscribing to PrivatePub messages
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions-table').append(JST["questions/create"](question: question))
#    $('.questions-table').append(data.html)

load_votable = ->
  window.Votable.set_votable_hooks('.question-vote-area')

$(document).ready(load_votable)
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

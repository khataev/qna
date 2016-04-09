# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question-form').show()

  $('.subscribe-area .subscribe-link')
    .bind 'ajax:success', subscribe_success
    .bind 'ajax:error', subscribe_error
    .bind 'ajax:before', subscribe_before

  # Subscribing to PrivatePub messages
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions-table').append(JST["questions/create"](question: question))
#    $('.questions-table').append(data.html)

load_votable = ->
  window.Votable.set_votable_hooks('.question-vote-area')

# subscription
subscribe_before = ->
  $('.subscribe-result').html('')

subscribe_success = (e, data, status, xhr) ->
  subscription = $.parseJSON(xhr.responseText)
  $('.subscribe-result').html('Subscription successful') if subscription
  $('.subscribe-link').hide() if subscription

subscribe_error = (e, xhr, status, error)  ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.vote-result').append(value + '<br/>')

$(document).ready(load_votable)
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

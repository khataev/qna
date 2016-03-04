# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

update_links_visibility = ->
  uphide = $('#link-vote-for').data('hide')
  downhide = $('#link-vote-against').data('hide')
  backhide = $('#link-vote-back').data('hide')
  $('#link-vote-for').hide() if uphide
  $('#link-vote-against').hide() if downhide
  $('#link-vote-back').hide() if backhide
#  console.log('u:' + uphide)
#  console.log('b:' + backhide)

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question-form').show()

vote_success = (e, data, status, xhr) ->
  question = $.parseJSON(xhr.responseText)
  $('.vote-counter').html(question.rating)
  $('#link-vote-for').hide()
  $('#link-vote-against').hide()
  $('#link-vote-back').show()

vote_back_success = (e, data, status, xhr) ->
  question = $.parseJSON(xhr.responseText)
  $('.vote-counter').html(question.rating)
  $('#link-vote-for').show()
  $('#link-vote-against').show()
  $('#link-vote-back').hide()

vote_error = (e, xhr, status, error)  ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.vote-errors').append(value + '<br/>')

vote_before = ->
  $('.vote-errors').html('')


$('.vote-up')
.bind 'ajax:success', vote_success
.bind 'ajax:error', vote_error
.bind 'ajax:before', vote_before

$('.vote-down')
.bind 'ajax:success', vote_success
.bind 'ajax:error', vote_error
.bind 'ajax:before', vote_before

$('.vote-back')
.bind 'ajax:success', vote_back_success
.bind 'ajax:error', vote_error
.bind 'ajax:before', vote_before

$(document).ready(update_links_visibility)
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)


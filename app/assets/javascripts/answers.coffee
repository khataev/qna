# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Объявляем функцию ready, внутри которой можно поместить обработчики событий и другой код, который должен выполняться при загрузке страницы
ready = ->
# Это наш обработчик, перенесенный сюда из docuement.ready ($ ->)
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

load_votable = ->
  window.Votable.set_votable_hooks('.answer-vote-area')

$(document).ready(load_votable)
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

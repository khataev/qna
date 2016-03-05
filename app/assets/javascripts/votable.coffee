window.Votable ?= {}

window.Votable.set_votable_hooks = (vote_area_name) ->
  update_links_visibility = ->
    uphide = $("#{vote_area_name} #link-vote-for").data('hide')
    downhide = $("#{vote_area_name} #link-vote-against").data('hide')
    backhide = $("#{vote_area_name} #link-vote-back").data('hide')
    $("#{vote_area_name} #link-vote-for").hide() if uphide
    $("#{vote_area_name} #link-vote-against").hide() if downhide
    $("#{vote_area_name} #link-vote-back").hide() if backhide
  #  console.log('u:' + uphide)
  #  console.log('b:' + backhide)

  vote_success = (e, data, status, xhr) ->
    votable = $.parseJSON(xhr.responseText)
    $("#{vote_area_name} .vote-counter").html(votable.rating)
    $("#{vote_area_name} #link-vote-for").hide()
    $("#{vote_area_name} #link-vote-against").hide()
    $("#{vote_area_name} #link-vote-back").show()

  vote_back_success = (e, data, status, xhr) ->
    votable = $.parseJSON(xhr.responseText)
    $("#{vote_area_name} .vote-counter").html(votable.rating)
    $("#{vote_area_name} #link-vote-for").show()
    $("#{vote_area_name} #link-vote-against").show()
    $("#{vote_area_name} #link-vote-back").hide()

  vote_error = (e, xhr, status, error)  ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $("#{vote_area_name} .vote-errors").append(value + '<br/>')

  vote_before = ->
    $("#{vote_area_name} .vote-errors").html('')


  $("#{vote_area_name} .vote-up")
  .bind 'ajax:success', vote_success
  .bind 'ajax:error', vote_error
  .bind 'ajax:before', vote_before

  $("#{vote_area_name} .vote-down")
  .bind 'ajax:success', vote_success
  .bind 'ajax:error', vote_error
  .bind 'ajax:before', vote_before

  $("#{vote_area_name} .vote-back")
  .bind 'ajax:success', vote_back_success
  .bind 'ajax:error', vote_error
  .bind 'ajax:before', vote_before

  $(document).ready(update_links_visibility)
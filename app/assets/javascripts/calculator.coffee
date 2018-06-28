# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'change', '#fee_scheme', ->
  fee_scheme = $(this).val()
  console.log fee_scheme
  $.ajax
    url: '/calculator/fee_scheme_changed'
    method: 'GET'
    data: fee_scheme: fee_scheme
    error: (xhr, status, error) ->
      console.error 'AJAX Error: ' + status + error
      return
    success: ->
      console.log 'success!'
      return
  return

$(document).on 'change', '.js-field-changer', ->
  scenario = $(this).val()
  fee_scheme = $('#fee_scheme').val()
  scenario = $('#scenario').val()
  advocate_type = $('#advocate_type').val()
  offence_class = $('#offence_class').val()
  fee_type_code = $('#fee_type_code').val()
  console.log scenario
  $.ajax
    url: '/calculator/select_list_changed'
    method: 'GET'
    data: fee_scheme: fee_scheme, scenario: scenario, advocate_type: advocate_type, offence_class: offence_class, fee_type_code: fee_type_code
    error: (xhr, status, error) ->
      console.error 'AJAX Error: ' + status + error
      return
    success: ->
      console.log 'success!'
      return
  return

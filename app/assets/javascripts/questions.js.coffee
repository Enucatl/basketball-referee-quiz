# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    time_started = new Date()
    $("input").click ->
        time_ended = new Date()
        answer_time = (time_ended - time_started) / 1000
        $("input#time").val answer_time
        $(this).closest("form").submit()

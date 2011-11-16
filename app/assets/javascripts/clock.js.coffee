$(document).ready ->
  tickClock = () ->
    $('time.clock').html moment().format('h:mm a')
    setTimeout tickClock, 333
  setTimeout tickClock, 333

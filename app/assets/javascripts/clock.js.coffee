$(document).ready ->
  tickClock = () ->
    $('time').html moment().format('hh:mm:ss')
    setTimeout tickClock, 333
  setTimeout tickClock, 333
Handlebars.registerHelper 'timestamp', (t) ->
  moment(t).format 'MM/DD hh:mm'

$(document).ready ->
  titleTemplate = Handlebars.compile $('#title-template').html()
  contentTemplate = Handlebars.compile $('#content-template').html()

  randomTimeout = ->
    Math.round Math.random() * 10000 # milliseconds

  cycleBox = (box) ->
    () ->
      box.find('.content:first-child').remove().appendTo box
      setTimeout cycleBox(box), randomTimeout()

  $.ajax '/ladygaga.json',
    dataType: 'json'

    error: (jqxhr, status, e) ->
      console.log "error #{status}: #{e}"

    success: (tweets, status) ->
      return unless tweets?
      console.log tweets
      user = tweets[0].user

      # title
      $('.title').append titleTemplate(user)

      # initialize boxes
      boxes = $ '.col:empty'

      # iterate over tweets, filling boxes
      _.each tweets, (tweet, i) ->
        box = boxes.filter ":eq(#{i % boxes.length})"
        box.append contentTemplate(tweet)

      # start cycling boxes
      _.each boxes, (box) ->
        setTimeout cycleBox($(box)), randomTimeout()

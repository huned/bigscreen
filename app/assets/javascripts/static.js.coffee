Handlebars.registerHelper 'timestamp', (t) ->
  moment(t).format 'MM/DD hh:mm'

$(document).ready ->
  titleTemplate = Handlebars.compile $('#title-template').html()
  contentTemplate = Handlebars.compile $('#content-template').html()
  videoTemplate = Handlebars.compile $('#video-template').html()
  thumbnailTemplate = Handlebars.compile $('#thumbnail-template').html()
  weatherTemplate = Handlebars.compile $('#weather-template').html()

  # weather
  $('.full-screen').append weatherTemplate()

  # video
  #$('.full-screen').append videoTemplate()

  randomTimeout = ->
    Math.round 2500 + Math.random() * 10000 # milliseconds

  cycleBox = (box) ->
    () ->
      box.find('.content:first-child').remove().appendTo box
      col = box.closest '.col'
      setTimeout cycleBox(box), randomTimeout()

  $.ajax '/ladygaga.json',
    dataType: 'json'

    error: (jqxhr, status, e) ->
      console.log "error #{status}: #{e}"

    success: (tweets, status) ->
      return unless tweets?
      #console.log tweets
      user = tweets[0].user

      # title
      $('.title').append titleTemplate(user)

      # initialize boxes
      boxes = $ '.col:empty'

      # iterate over tweets, filling boxes
      _.each tweets, (tweet, i) ->
        box = boxes.filter ":eq(#{i % boxes.length})"
        content = $ contentTemplate(tweet)

        if box.is '.with-thumbnail'
          image =
            image_url: '/assets/ladygaga/square-1.jpg'
            orientation: 'square'
            float: 'left'

          if box.is('.with-horizontal-thumbnail')
            image.orientation = 'horizontal'
            image.image_url = '/assets/ladygaga/horizontal-1.jpg'
          else if box.is('.with-vertical-thumbnail')
            image.orientation = 'vertical'
            image.image_url = '/assets/ladygaga/vertical-1.jpg'

          content.prepend thumbnailTemplate(image)

        box.append content

      # start cycling boxes
      _.each boxes, (box) ->
        setTimeout cycleBox($(box)), randomTimeout()

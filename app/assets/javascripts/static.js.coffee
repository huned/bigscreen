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
      box.addClass 'flip'
      setTimeout () ->
        box.removeClass 'flip'
        setTimeout cycleBox(box), randomTimeout()
      , randomTimeout()

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

        frontOrBack = 'back'
        frontOrBack = 'front' if box.is ':empty'

        content = $(contentTemplate(tweet)).addClass frontOrBack

        if box.is '.with-thumbnail'
          image =
            image_url: '/assets/ladygaga/square-1.jpg'
            orientation: 'square'
            float: 'left'

          if box.is('.with-horizontal-thumbnail')
            image.orientation = 'horizontal'
            image.image_url =
              if frontOrBack == 'front'
                '/assets/ladygaga/horizontal-1.jpg'
              else
                '/assets/ladygaga/horizontal-2.jpg'
          else if box.is('.with-vertical-thumbnail')
            image.orientation = 'vertical'
            image.image_url =
              if frontOrBack == 'front'
                '/assets/ladygaga/vertical-1.jpg'
              else
                '/assets/ladygaga/vertical-2.jpg'

          content.prepend thumbnailTemplate(image)

        box.find('.back').remove() # for now, only allow one back panel
        box.append content

      # start cycling boxes
      _.each boxes, (box) ->
        setTimeout cycleBox($(box)), randomTimeout()

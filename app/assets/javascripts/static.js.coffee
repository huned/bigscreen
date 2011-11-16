Handlebars.registerHelper 'timestamp', (t) ->
  moment(t).format 'MM/DD hh:mm'

$(document).ready ->
  titleTemplate = Handlebars.compile $('#title-template').html()
  contentTemplate = Handlebars.compile $('#content-template').html()
  videoTemplate = Handlebars.compile $('#video-template').html()
  thumbnailTemplate = Handlebars.compile $('#thumbnail-template').html()
  weatherTemplate = Handlebars.compile $('#weather-template').html()

  # weather
  fullScreenContent = () ->
    @b ||= weatherTemplate
    @a ||= videoTemplate
    [@a, @b] = [@b, @a]
    @a()

  fullScreenTimeout = (t) ->
    if t == weatherTemplate
      10000
    else
      40000

  setInterval () ->
    $('.col').addClass 'pause'
    $('.full-screen').html(fullScreenContent()).addClass 'active'
    setTimeout () ->
      $('.col').removeClass 'pause'
      $('.full-screen').removeClass('active').empty()
    , fullScreenTimeout(@a)
  , 120000

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
        setInterval (() ->
          $(box).not('.pause').toggleClass 'flip'
        ), 2500 + Math.random() * 10000

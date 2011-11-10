// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  //
  // poor man's clock
  //
  var time = $('time');
  var updateTime = function() {
    var d = new Date
      , h = d.getHours()
      , m = d.getMinutes()
      , s = d.getSeconds();

    h = h < 10 ? '0' + h : h;
    m = m < 10 ? '0' + m : m;
    s = s < 10 ? '0' + s : s;

    time.html(h + ':' + m + ':' + s);
    setTimeout(updateTime, 1000);
  }
  setTimeout(updateTime, 1000);




  var boxes = $('.col:empty');

  // populate tweets on page
  $.ajax('/ladygaga.json', {
    dataType: 'json',
    error: function(jqxhr, status, e) {
      console.log('error: ' + status + ' ' + e);
    },
    success: function(data, status, jqxhr) {
      console.log(data);

      var i = 0;

      // populate title
      $('.title h1').html(data[0].user.name + "'s Tweets");

      // populate content boxes
      data.forEach(function(tweet) {
        var box = $(boxes[i]);
        if (box.is(':empty')) {
          $('<div class="current">').html(tweet.text).appendTo(box);
        } else {
          var queue = box.find('.queue');
          if (queue.length < 1) {
            $('<div class="queue">').appendTo(box);
            queue = box.find('.queue');
          }
          $('<div class="item">').html(tweet.text).appendTo(queue);
        }

        i++;
        if (i > boxes.length - 1) i = 0; // reset count
      });

      // finally kick off animations
      var updateBox = function(box) {
        var item = box.find('.item:first-child').remove();
        var text = item.html();
        item.html(box.find('.current').html()).appendTo(box.find('.queue'));
        box.find('.current').html(text);
        setTimeout(function() {
          updateBox(box);
        }, Math.round(Math.random() * 10000));
      };

      $.makeArray(boxes).forEach(function(box) {
        var box = $(box);
        setTimeout(function() {
          updateBox(box);
        }, Math.round(Math.random() * 10000));
      });
    }
  });
});

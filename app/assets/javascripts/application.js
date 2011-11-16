// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//
// vendor/assets/javascripts
// -------------------------
//= require json2
//= require handlebars.1.0.0.beta.3
//= require underscore-min
//= require backbone-min
//= require moment.min
//
//= require_tree .

// via http://stackoverflow.com/questions/698301/is-there-a-native-jquery-function-to-switch-elements
jQuery.fn.swapWith = function(to) {
    return this.each(function() {
        var copy_to = $(to).clone(true);
        $(to).replaceWith(this);
        $(this).replaceWith(copy_to);
    });
};

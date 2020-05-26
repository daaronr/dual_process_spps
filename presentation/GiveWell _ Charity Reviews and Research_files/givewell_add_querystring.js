(function ($) {
  Drupal.behaviors.gwAddQuerystring = {
    attach: function (context, settings) {
    var queryString = location.search;
    var referrerString = document.referrer;
    if (referrerString.length > 0 && queryString.length > 0) {
      var trackerString = queryString + "&referrer_header=" + referrerString;
    } else if (queryString.length == 0 && referrerString.length > 0) {
      var trackerString = "?referrer_header=" + referrerString; 
    } else if (queryString.length > 0 && referrerString.length == 0) {
      var trackerString = queryString;
    }
    if (typeof(trackerString) != 'undefined' && trackerString.length > 0) {
      $(".append-tracker").each(function() { $(this).attr("href", $(this).attr("href")+ trackerString); });
    }
  }
 };
})(jQuery);

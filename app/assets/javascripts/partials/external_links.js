// External links

App.isExternalLink = function($el) {
  var documentHost = document.location.href.split('/')[2];
  var internalLinkExceptions = ['mailto:', 'tel:', 'sms:', 'javascript:'];
  var href = $el.attr('href');
  var link = $el.get(0).href;
  var linkHost = link.split('/')[2];
  var internalLinkMatches = $.map(internalLinkExceptions, function(d) {
    if ( href ) {
      return href.indexOf(d) != -1;
    } else {
      return true;
    }
  });

  return linkHost != documentHost && ( $.inArray(true, internalLinkMatches) === -1 );
};

App.pageLoad.push(function() {
  $('a').each(function() {
    var $link = $(this);

    if ( App.isExternalLink($link) ) {
      var target = $link.attr('target');

      if ( !target ) {
        target = '_blank';
      }

      $link.attr('target', '_blank')
           .addClass('external-link');
    }
  });
});

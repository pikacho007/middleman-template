var ua = navigator.userAgent;
if(ua.match(/(msie|MSIE)/) || ua.match(/(T|t)rident/)) {
  var ieVersion = parseInt(ua.match(/((msie|MSIE)\s|rv:)([\d\.]+)/)[3]);
  document.body.className += ' ie'+ieVersion;
}
else if(ua.match(/Edge/i)) {
  document.body.className += ' edge';
}

document.isMobile = false;
document.isTablet = false;
if(
  ua.match(/iPhone/i) ||
  ua.match(/iPod/i) ||
  (ua.match(/Android/i) && ua.match(/Mobile/i)) ||
  ua.match(/iPad/i) ||
  ua.match(/Android/i)
  ) {
  document.isMobile = true;
}
if(
  ua.match(/iPad/i) ||
  (ua.match(/Mobile/i) && ua.match(/Android/i))
  ) {
  document.isTablet = true;
  var $meta = $('head>meta[name="viewport"]');
  $meta.attr('content', $meta.attr('content').replace(/width=(\d+|device-width)/g, 'width=1024'));
}

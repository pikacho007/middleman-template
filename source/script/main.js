var ua = navigator.userAgent;
if( ua.match(/(msie|MSIE)/) || ua.match(/(T|t)rident/) ) {
  var ieVersion = parseInt(ua.match(/((msie|MSIE)\s|rv:)([\d\.]+)/)[3]);
  document.body.className += ' ie'+ieVersion;
}
else if( ua.match(/Edge/) ) {
  document.body.className += ' edge';
}

document.isMobile = false;
document.isTablet = false;
if(
  0 < ua.indexOf('iPhone') ||
  0 < ua.indexOf('iPod') ||
  (0 < ua.indexOf('Android') && 0 < ua.indexOf('Mobile')) ||
  0 < ua.indexOf('iPad') ||
  0 < ua.indexOf('Android')
) {
  document.isMobile = true;
}
if(
  0 < ua.indexOf('iPad') ||
  (ua.indexOf('Mobile') == 0 && 0 < ua.indexOf('Android'))
) {
  document.isTablet = true;
  var $meta = $('head>meta[name="viewport"]');
  $meta.attr('content', $meta.attr('content').replace(/width=(\d+|device-width)/g, 'width=1024'));
}

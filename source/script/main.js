var ua = navigator.userAgent;
if(ua.match(/(msie|MSIE)/) || ua.match(/(T|t)rident/)) {
  var ieVersion = parseInt(ua.match(/((msie|MSIE)\s|rv:)([\d\.]+)/)[3]);
  document.body.className += ' ie'+ieVersion;
}
else if(ua.match(/Edge/i)) {
  document.body.className += ' edge';
}

document.isMobile = false;
if(
  ua.match(/iPhone/i) ||
  ua.match(/iPod/i) ||
  (ua.match(/Android/i) && ua.match(/Mobile/i)) ||
  ua.match(/iPad/i) ||
  ua.match(/Android/i)
  ) {
  document.isMobile = true;
}

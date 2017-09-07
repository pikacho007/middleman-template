var ua = navigator.userAgent;
document.isIE = ua.match(/msie/i);
document.isIE6 = ua.match(/msie [6.]/i);
document.isIE7 = ua.match(/msie [7.]/i);
document.isIE8 = ua.match(/msie [8.]/i);
document.isIE9 = ua.match(/msie [9.]/i);
document.isIE10 = ua.match(/msie [10.]/i);
document.isIE10 = ua.match(/msie [11.]/i);

if(document.isIE){
  document.body.className += 'ie';
  if(document.isIE6){
    document.body.className += 'ie6';
  }
  else if(document.isIE7) {
    document.body.className += 'ie7';
  }
  else if(document.isIE8) {
    document.body.className += 'ie8';
  }
  else if(document.isIE9) {
    document.body.className += 'ie9';
  }
  else if(document.isIE10) {
    document.body.className += 'ie10';
  }
  else if(document.isIE11) {
    document.body.className += 'ie11';
  }
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
}
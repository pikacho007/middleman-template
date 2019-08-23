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

document.scrollTo = function(_target, _offset, _speed, _callback) {
  const offset = _offset || 0;
  const target = (_target instanceof jQuery) ? _target : $(_target);
  let position;
  if(target.prop('tagName') == 'BODY') {
    position = 0;
  }
  else {
    position = target.offset().top - offset;
  }
  $('html,body').animate({scrollTop: position}, _speed || 500, 'easeOutQuart', _callback);
};

$(function() {
  $(document)
    // ページ内リンク
    .on('click', 'a[href^=\\#]', function(e) {
      e.preventDefault();
      const id = '#'+$(e.target).closest('a').attr('href').split('#')[1];
      // ターゲットの要素側で上マージンが設定してあったらそれを取得
      const margin = $(id).attr('data-scroll-margin') || 20;
      document.scrollTo(id, margin);
    })
});
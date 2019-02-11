var pushbar = new Pushbar({
  blur: false,
  overlay: false,
});

var loading_screen;

Shiny.addCustomMessageHandler('loading', function(msg) {
  loading_screen = pleaseWait({
    backgroundColor: '#1976D2',
    loadingHtml: '<div class="sk-chasing-dots"><div class="sk-child sk-dot1"></div><div class="sk-child sk-dot2"></div></div><br>' + 
      '<span color="#fff">' + msg + '</span>'
  });
});

Shiny.addCustomMessageHandler('done', function(msg) {
  loading_screen.finish();
});
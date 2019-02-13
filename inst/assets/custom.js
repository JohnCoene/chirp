var pushbar = new Pushbar({
  blur: false,
  overlay: false,
});

var loading_screen;

Shiny.addCustomMessageHandler('load', function(msg) {
  loading_screen = pleaseWait({
    logo: "",
    backgroundColor: "#1976D2",
    loadingHtml: '<div class="sk-chasing-dots"><div class="sk-child sk-dot1"></div><div class="sk-child sk-dot2"></div></div><br>' + 
      '<span style="color:#fff;">' + msg + '</span>'
  });
});

Shiny.addCustomMessageHandler('unload', function(msg) {
  loading_screen.finish();
});

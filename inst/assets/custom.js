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

Shiny.addCustomMessageHandler('close', function(msg) {
  pushbar.close();
});

Shiny.addCustomMessageHandler('open', function(msg) {
  pushbar.open(msg);
});

// CUSTOM LABELS

$(document).on("click", ".networks-legend", function(evt) {

  // evt.target is the button that was clicked
  var el = $(evt.target);

  // Set the button's text to its current value plus 1
  console.log(el[0].id);

  // Raise an event to signal that the value changed
  el.trigger("change");
});

var legendBinding = new Shiny.InputBinding();
$.extend(legendBinding, {
  find: function(scope) {
    return $(scope).find(".networks-legend");
  },
  getValue: function(el) {
    return $(el).value
  },
  setValue: function(el, value) {
    $(el).value;
  },
  subscribe: function(el, callback) {
    $(el).on("change.legendBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".legendBinding");
  }
});

Shiny.inputBindings.register(legendBinding);

MicroModal.init();
Shiny.addCustomMessageHandler('open-vr-modal', function(msg) {
  MicroModal.show('vr-modal');
});

Blacklight.onLoad(function() {
  var tpp = require('triple_powered_properties/control');
  $('.triple_powered_property').each(function() {
    new tpp.TriplePoweredPropertyControl(this);
  });
});

require('coffee-script');

// Exports
['massage', 'undermix'].forEach(function(name) {
  var path = './lib/' + name
  var module = require(path);
  for (var i in module) {
    exports[i] = module[i];
  }
});

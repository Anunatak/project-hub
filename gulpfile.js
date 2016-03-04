var Elixir = require('laravel-elixir');

require('./tasks/coffeeify');
require('./tasks/hbsfy');

Elixir(function(mix) {
	mix.browserify('./src/js/app.coffee', './dist/js/app.js');
});

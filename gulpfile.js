var Elixir = require('laravel-elixir');

require('./tasks/coffeeify');

Elixir(function(mix) {
	mix.browserify('./src/js/app.coffee', './dist/js/app.js');
});

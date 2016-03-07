## Load modules
Hub = require './classes/Hub.coffee'
$   = require 'jquery'

# Start the hub
hub = new Hub('#timeline', '');

# Fetch hub data
hub.fetch () ->
	@timelineView.render()
	document.title = @project.get 'name'
	$('h1#project-name').html @project.get 'name'


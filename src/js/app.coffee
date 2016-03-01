## Load modules
$        = require('jquery')
Backbone = require 'backbone'
_        = require 'underscore'
moment   = require 'moment'

## Set backbone's Jquery
Backbone.$ = $

## Namespace
App =
	Models: {}
	Collections: {}

## Create the milestone model
App.Models.Milestone = Backbone.Model.extend
	defaults:
		'title': ''
		'date': moment()
		'text': ''
		'link': null
	initialize: () ->
		@date = moment @date, 'YYYY/MM/DD'

## Create the milestones collection
App.Collections.Milestones = Backbone.Collection.extend
	url: '/project.json'
	initialize: () ->
		@fetch()
	model: App.Models.Milestone
	parse: (response) ->
		response.milestones

App.Milestones = new App.Collections.Milestones();

$(window).load () ->
	console.log(App.Milestones.length);

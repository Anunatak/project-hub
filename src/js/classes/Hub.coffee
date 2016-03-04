# Load modules
$                = require 'jquery'
Backbone         = require 'backbone'
_                = require 'underscore'
moment           = require 'moment'
SortedCollection = require 'backbone-sorted-collection'

# Set moment locale
require 'moment/locale/nb'

## Set backbone's Jquery
Backbone.$ = $

# Create class
class Hub
	constructor: (@el) ->
		@template     = require '../../templates/item.hbs'
		@models       = {}
		@collections  = {}
		@views        = {}
		@milestones   = null
		@timelineView = null
		@createModels()
		@createViews()
		@createCollections()
		@initialize()

	createModels: () ->
		@models.Milestone = Backbone.Model.extend
			defaults:
				'title': ''
				'date': moment()
				'text': ''
				'link': null
			initialize: () ->
				# @date = moment @date, 'YYYY/MM/DD'
				# @date = @date.format 'D. MMMM YYYY'
			parse: (response) ->
				response.date = moment response.date, 'YYYY/MM/DD'
				response.date = response.date.format 'D. MMMM YYYY'
				response
		@models.Project = Backbone.Model.extend
			url: '/project.json'
			parse: (response) ->
				delete response.milestones
				response

	createCollections: () ->
		@collections.Milestones = Backbone.Collection.extend
			url: '/project.json'
			model: @models.Milestone
			comparator: (model) ->
				date = moment model.get('date'), 'D. MMMM YYYY'
				return date.format 'YYYYMMDD'
			parse: (response) ->
				response.milestones
	createViews: () ->
		@views.Timeline = Backbone.View.extend
			el: @el
			template: @template
			render: () ->
				html = @template @collection.toJSON()
				this.$el.html html

	initialize: () ->
		@project = new @models.Project()
		@milestones = new @collections.Milestones()
		@milestones.sort();
		@timelineView = new @views.Timeline
			collection: @milestones

	fetch: (callback) ->
		that = @
		@project.fetch
			success: () ->
				that.milestones.add that.project.
				callback.call that

module.exports = Hub

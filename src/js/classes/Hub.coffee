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
		that = @
		@models.Milestone = Backbone.Model.extend
			defaults:
				'title': ''
				'date': moment()
				'text': ''
				'link': null
			parse: (response) ->
				response.date = moment response.date, 'YYYY/MM/DD'
				response.date = response.date.format that.project.get 'date_format'
				response
			toJSON: () ->
				attrs = _.clone @attributes
				date = moment attrs.date, 'YYYY/MM/DD'
				attrs.date = date.format that.project.get 'date_format'
				attrs

		@models.Project = Backbone.Model.extend
			url: '/project.json'
			parse: (response) ->
				response

	createCollections: () ->
		that = @
		@collections.Milestones = Backbone.Collection.extend
			model: @models.Milestone
			comparator: (model) ->
				date = moment model.get('date'), that.project.get 'date_format'
				date.format 'YYYYMMDD'

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
				that.milestones.add that.project.get 'milestones'
				callback.call that

module.exports = Hub

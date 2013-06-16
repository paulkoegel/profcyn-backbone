'use strict'

class BB.GalleryShowView extends Backbone.Marionette.ItemView

  className: 'm-gallery'

  initialize: ->
    @template = 'galleries_show'
    console.log '@model:', @model
    console.log 'GalleryShowView#initialize'
    @model.on 'change', @render

  onRender: ->
    console.log 'GalleryShow#onRender'
    console.log @

'use strict'

class BB.GalleriesController extends Marionette.Controller

  initialize: ->
    console.log 'GalleriesController: initialize'

  index: ->
    console.log 'GalleriesController#index'
    gallery = new BB.GalleryModel(id: 1)
    BB.appLayout.content.show(new BB.GalleryShowView(model: gallery))
    gallery.fetch()

  show: ->
    console.log 'GalleriesController#show'

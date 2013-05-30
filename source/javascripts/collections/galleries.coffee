'use strict'

class BB.GalleriesCollection extends Backbone.Collection

  initialize: ->
    @url = BB.apiRoot + '/galleries'
    @model = BB.GalleryModel

'use strict'

class BB.GalleryModel extends Backbone.Model

  url: '/galleries'

  initialize: ->
    url = BB.apiRoot + '/galleries'

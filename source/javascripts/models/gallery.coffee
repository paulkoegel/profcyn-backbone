'use strict'

class BB.GalleryModel extends Backbone.Model

  initialize: (attrs) ->
    @url = BB.apiRoot + '/galleries/' + @get('id')

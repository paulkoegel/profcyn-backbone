'use strict'

$ ->

  console.log 'document ready'

  # required for proper server-side processing of request
  $.ajaxSetup
    beforeSend: (xhrObj) ->
      xhrObj.setRequestHeader("Content-Type","application/json")
      xhrObj.setRequestHeader("Accept","application/json")

  class GalleryCollection extends Backbone.Collection
    url: 'http://localhost:4000/galleries'
  
  galleries = new GalleryCollection()
  galleries.fetch
    success: (response) ->
      console.log galleries

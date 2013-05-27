'use strict'

BB.app = new Marionette.Application()
BB.app.addRegions
  mainWrapper: '#bb-marionette-wrapper'

BB.app.addInitializer (options) ->
  BB.appRouter = new BB.AppRouter()

BB.app.on 'initialize:after', ->
  BB.appLayout = new BB.AppLayout()
  BB.app.mainWrapper.show(BB.appLayout)
  if Backbone.history
    Backbone.history.start
      pushState: true


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

  BB.app.start()

'use strict'

BB.app = new Marionette.Application()
BB.app.addRegions
  mainWrapper: '#bb-marionette-wrapper'

BB.app.addInitializer (options) ->
  BB.appRouter = new BB.AppRouter()
  # BB.sessionsController = new BB.SessionsController()

BB.app.on 'initialize:after', ->
  BB.appLayout = new BB.AppLayout()
  BB.app.mainWrapper.show(BB.appLayout)
  if Backbone.history
    Backbone.history.start()
      #pushState: true # have to use URL fragments until grunt-connect-rewrite works properly

$ ->

  console.log 'document ready'

  BB.debug = true # only for development mode!

  BB.apiRoot = 'http://localhost:4000'

  # $.ajaxPrefilter (options, originalOptions, jqXHR) ->
  #   options.url = 'http://localhost:4000' + options.url
  
  # required for proper server-side processing of request
  $.ajaxSetup
    beforeSend: (xhrObj) ->
      xhrObj.setRequestHeader("Content-Type","application/json")
      xhrObj.setRequestHeader("Accept","application/json")

  console.log 'fetching galleries'
  BB.galleries = new BB.GalleriesCollection()
  BB.galleries.fetch
    success: (response) ->
      console.log BB.galleries

  BB.app.start()

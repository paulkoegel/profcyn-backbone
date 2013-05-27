'use strict'

class BB.AppRouter extends Backbone.Marionette.AppRouter

  initialize: ->
    console.log 'Router: initialize'

  routes:
    '': 'root'
    'admin': 'login'
    'login': 'login'

  root: ->
    console.log 'appRouter#root'

  login: ->
    console.log 'appRouter#login'
    loginView = new BB.LoginView()
    BB.appLayout.content.show(loginView)

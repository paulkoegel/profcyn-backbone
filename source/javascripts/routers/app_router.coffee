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
    BB.appLayout.navigation.show(new BB.NavigationView())
    BB.appLayout.content.close()

  login: ->
    console.log 'appRouter#login'
    BB.appLayout.navigation.show(new BB.NavigationView())
    BB.appLayout.content.show(new BB.LoginView())

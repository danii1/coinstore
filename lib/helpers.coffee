Handlebars.registerHelper 'userIsAdmin', ->
  currentUser = Meteor.user()
  return currentUser? and Roles.userIsInRole(currentUser._id, ['administrator'])

Handlebars.registerHelper 'storeName', ->
  Meteor.settings.public.storeName

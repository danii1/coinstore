@Currencies = new Meteor.Collection('currencies')

@Currencies.allow({
  insert: (userId, doc) ->
    false
  update: (userId, doc, fields, modifier) ->
    false
  remove: (userId, doc) ->
    false
})

@Purchases = new Meteor.Collection('purchases')

@Purchases.allow({
  insert: (userId, doc) ->
    userId? # allow new purchases for logged in users
  update: (userId, doc, fields, modifier) ->
    false # only server should be able to update purchases
  remove: (userId, doc) ->
    false
})

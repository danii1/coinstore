Template.purchases.activePurchases = ->
  currentUser = Meteor.user()
  if currentUser?
    return Purchases.find({status: 'awaiting_payment', user_id: currentUser._id }, {sort: {created_at: -1}})
  return null

Template.purchases.completedPurchases = ->
  currentUser = Meteor.user()
  if currentUser?
    return Purchases.find({status: 'paid', user_id: currentUser._id }, {sort: {updated_at: -1}})
  return null

Template.purchases.cancelledPurchases = ->
  currentUser = Meteor.user()
  if currentUser?
    return Purchases.find({status: 'cancelled', user_id: currentUser._id }, {sort: {updated_at: -1}})
  return null

Template.purchases.purchaseItem = ->
  Items.findOne(@item_id)

Template.purchases.events({
  'click button#cancelPurchase': (event) ->
    event.preventDefault()
    Meteor.call 'cancelPurchase', @_id
})

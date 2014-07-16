Template.adminPurchases.purchases = ->
  return Purchases.find({}, {sort: {created_at: -1}})

Template.adminPurchases.purchaseItem = ->
  Items.findOne(@item_id)

Template.adminPurchases.purchaseUserEmail = ->
  user = Meteor.users.findOne(@user_id)
  if user?
    return user.emails[0].address
  else
    return null

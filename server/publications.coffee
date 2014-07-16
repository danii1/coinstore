Meteor.publish 'items', ->
  if @userId? and Roles.userIsInRole(@userId, ['administrator'])
    return Items.find({}, { fields: {title: true, quantity: true, type: true, price:true, currency:true}})
  else
    return Items.find({quantity: { $gt: 0 }}, { fields: {title: true, quantity: true}} )

Meteor.publish 'itemDetail', (itemId) ->
  return Items.find(itemId)

Meteor.publish 'users', ->
  if @userId? and Roles.userIsInRole(@userId, ['administrator'])
    return Meteor.users.find()
  return null

Meteor.publish 'purchases', ->
  if @userId?
    if Roles.userIsInRole(@userId, ['administrator'])
      return Purchases.find()
    else
      return Purchases.find({user_id: @userId})
  return null

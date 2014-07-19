Meteor.publish 'items', ->
  collectionFilter = {quantity: { $gt: 0 }}
  if @userId? and Roles.userIsInRole(@userId, ['administrator'])
    collectionFilter = {}
  return Items.find(collectionFilter, { fields: {title: true, titleImage: true, quantity: true, type: true, price: true, currency: true}})

Meteor.publish 'itemDetail', (itemId) ->
  return Items.find(itemId)

Meteor.publish 'images', ->
  return Images.find() # debug

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

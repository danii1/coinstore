# get titleImage for item to display in list until we find a sane way to cache titleImageUrl
Meteor.smartPublish 'items', ->
  this.addDependency('items', 'titleImage', (item) ->
    if item.titleImage?
      return [ Images.find(item.titleImage._id) ]
    return []
  )

  collectionFilter = {quantity: { $gt: 0 }}
  collectionFilter = {} if @userId? and Roles.userIsInRole(@userId, ['administrator'])
  return Items.find(collectionFilter, { fields: {title: true, titleImage: true, quantity: true, type: true, price: true, currency: true}})

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

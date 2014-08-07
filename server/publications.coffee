# get titleImage for item to display in list until we find a sane way to cache titleImageUrl
Meteor.smartPublish 'items', ->
  this.addDependency('items', 'titleImage', (item) ->
    if item.titleImage?
      return [ Images.find(item.titleImage._id) ]
    return []
  )

  collectionFilter = {quantity: { $gt: 0 }}
  collectionFilter = {} if @userId? and Roles.userIsInRole(@userId, ['administrator'])
  return Items.find(collectionFilter, { fields: {title: 1, titleImage: 1, quantity: 1, type: 1, price: 1, currency: 1}})

Meteor.smartPublish 'itemDetails', (itemId) ->
  if @userId? and Roles.userIsInRole(@userId, ['administrator'])
    this.addDependency('items', 'deliveryContent', (item) ->
      if item.deliveryContent?
        return [ DeliveryContent.find(item.deliveryContent._id) ]
      return []
    )

    return Items.find(itemId)
  else
    return Items.find(itemId, { fields: {title: 1, titleImage: 1, quantity: 1, type: 1, description: 1, price: 1, currency: 1, quantity: 1}})

Meteor.publish 'users', ->
  if @userId? and Roles.userIsInRole(@userId, ['administrator'])
    return Meteor.users.find()
  return []

Meteor.publish 'currencies', ->
  if Roles.userIsInRole(@userId, ['administrator'])
    return Currencies.find()
  return []

Meteor.publish 'purchases', ->
  if @userId?
    if Roles.userIsInRole(@userId, ['administrator'])
      return Purchases.find()
    else
      return Purchases.find({user_id: @userId})
  return []


Meteor.smartPublish 'purchaseDetails', (purchaseId) ->
  this.addDependency('purchases', 'item_id', (purchase) ->
    if purchase.status=='paid' and purchase.item_id?
      return [ Items.find(purchase.item_id, { fields: {deliveryType: 1, deliveryContent: 1}}) ]
    return []
  )
  this.addDependency('items', 'deliveryContent', (item) ->
    if item.deliveryContent?
      return [ DeliveryContent.find(item.deliveryContent._id) ]
    return []
  )
  return Purchases.find({_id: purchaseId, user_id: @userId})

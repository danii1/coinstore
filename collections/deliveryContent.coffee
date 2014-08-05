@DeliveryContent = new FS.Collection('deliveryContent', {
  stores: [new FS.Store.FileSystem('deliveryContent', {path: '~/coinstore/uploads/delivery_content'})]
})

@DeliveryContent.allow({
  insert: (userId, doc) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  update: (userId, doc, fields, modifier) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  remove: (userId, doc) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  download: (userId, doc) ->
    if userId?
      # administrator can download everything
      return true if Roles.userIsInRole(userId, ['administrator'])
      # check user tries to download file that was purchased
      purchasedItemsIds = Purchases.find({user_id: userId}, { fields: {item_id: 1}}).map (purchase) -> purchase.item_id
      purchasedItems = Items.find({_id: { $in: purchasedItemsIds}}, { fields: {deliveryContent: 1}})
      allowDownload = false
      purchasedItems.forEach (item) ->
        if item.deliveryContent._id == doc._id
          allowDownload = true
      return allowDownload
    else
      false
})

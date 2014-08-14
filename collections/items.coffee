@Items = new Meteor.Collection('items',
  schema:
    title:
      type: String
      label: 'Title'
    titleImage:
      type: FS.File
      label: 'Title image'
      optional: true
      blackbox: true
    titleImageUrl:
      type: String
      optional: true
    additionalImages:
      type: [FS.File]
      label: 'Additional images'
      optional: true
      blackbox: true
    type:
      type: String
      label: 'Item type'
      allowedValues: ['digital']
    description:
      type: String
      label: 'Description'
    price:
      type: Number
      label: 'Price'
      decimal: true
      min: 0
    currency:
      type: String
      label: 'Currency'
    quantity:
      type: Number
      label: 'Quantity'
      min: 0
      index: true
    deliveryType:
      type: String
      label: 'Delivery type'
      allowedValues: ['protected_download']
    deliveryContent:
      type: FS.File
      label: 'Protected file'
      optional: true
      blackbox: true
)

@Items.allow({
  insert: (userId, doc) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  update: (userId, doc, fields, modifier) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  remove: (userId, doc) ->
    # check if user is admin and we don't have purchases of this item
    isAdmin = userId? and Roles.userIsInRole(userId, ['administrator'])
    noPurchases = Purchases.find({item_id:doc._id}).count() == 0
    return isAdmin and noPurchases
})


#SimpleSchema.debug = true

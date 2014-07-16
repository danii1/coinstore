Template.storefront.items = ->
  return Items.find({quantity: { $gt: 0 }})

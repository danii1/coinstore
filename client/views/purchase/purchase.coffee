Template.purchase.purchaseItem = ->
  return Items.findOne(@item_id)

Template.purchase.hasBeenPurchased = ->
  @status == 'paid'

Template.purchase.displayDownloadLink = ->
  item = Items.findOne(@item_id)
  if item? and item.deliveryType == 'protected_download' and item.deliveryContent?
    return true
  else
    return false

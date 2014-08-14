Meteor.methods
  populateAvailableCurrencies: () ->
    url = 'https://c-cex.com/t/pairs.json'
    response = HTTP.call('GET',url)
    if response? and response.content?
      result = JSON.parse(response.content)
      pairs = _.reject result.pairs, (pair) -> pair.indexOf('usd') != -1
      currencies = pairs.map (pair) -> pair.split('-', 1)[0].toUpperCase()
      currencies.unshift 'BTC'
      Currencies.upsert({gateway: 'ccex'}, {gateway: 'ccex', currencies: currencies})
    return

  changeTitleImage: (docId, image) ->
    user = Meteor.user()
    return unless user? and Roles.userIsInRole(user, ['administrator'])?
    Items.update(docId, { $set: { titleImage: image } })

  changeDeliveryContent: (docId, file) ->
    user = Meteor.user()
    return unless user? and Roles.userIsInRole(user, ['administrator'])?
    Items.update(docId, { $set: { deliveryContent: file } })

  pushAdditionalImage: (docId, image) ->
    user = Meteor.user()
    return unless user? and Roles.userIsInRole(user, ['administrator'])?
    Items.update(docId, { $push: { additionalImages: image } })

  pullAdditionalImage: (docId, image) ->
    user = Meteor.user()
    return unless user? and Roles.userIsInRole(user, ['administrator'])?
    Items.update(docId, { $pull: { additionalImages: image }})
    Images.remove(image._id)

  cancelPurchase: (purchaseId) ->
    #console.log 'cancelPurchase called', purchaseId
    purchase = Purchases.findOne(purchaseId)
    if purchase? and purchase.status != 'paid' and purchase.status != 'cancelled'
      Purchases.update(purchaseId, {
        $set: {
          status: 'cancelled'
          updated_at: new Date()
        }
      })

      Items.update(purchase.item_id, {$inc: {quantity: 1}} )


  # use server side method to not reveal merchant id
  purchaseItem: (id) ->
    console.log 'purchaseItem called', id
    return unless Meteor.user()?

    item = Items.findOne(id)
    #ensure that we have enough pieces in out inventory
    return null unless item.quantity > 0

    Items.update(id, {$inc: {quantity: -1}} )

    purchaseId = Purchases.insert({
      expected_payment_amount: item.price
      expected_payment_currency: item.currency
      item_id: item._id
      quantity: 1
      status: 'awaiting_payment'
      created_at: new Date()
      updated_at: null
      user_id: Meteor.user()._id
    })

    #debug
    #return '/purchase?ccexmpurchaseid='+purchaseId

    url = 'https://c-cex.com/m.html?m=' + Meteor.settings.gateways.ccex.merchantId

    response = HTTP.call('POST',url, {
      params:
        coin: item.currency
        amount: item.price
        purchase_id: purchaseId
        purchase_name: item.title
    })

    if response.statusCode? and response.statusCode == 302
      if response.headers? and response.headers.location?
        redirectUrl = response.headers.location
        return 'https://c-cex.com/' + redirectUrl

    return null

  verifyPurchase: (merchantTransactionId, purchaseId) ->
    if merchantTransactionId? and purchaseId?
      url = 'https://c-cex.com/m.html?qid=' + merchantTransactionId + '&qpid=' + purchaseId
      response = HTTP.call('GET',url)
      if response? and response.content?
        result = JSON.parse(response.content)

        paidAmount = parseFloat(result.return.total)
        paidCurrency = result.return.coin
        #paidAmount = 0.00001 # debug
        if paidAmount > 0
          purchase = Purchases.findOne(purchaseId)
          # purchase should have status "created", if it does have other status then we have some non standard behaviour
          if purchase? and purchase.status != 'paid'
            statusUpdate = null

            if purchase.expected_payment_amount <= paidAmount and purchase.expected_payment_currency.toUpperCase() == paidCurrency.toUpperCase()
              statusUpdate = 'paid'

            if purchase.expected_payment_amount > paidAmount and purchase.expected_payment_currency.toUpperCase() == paidCurrency.toUpperCase()
              statusUpdate = 'partial_payment'

            if statusUpdate?
              Purchases.update(purchase._id, {
                $set: {
                  status: statusUpdate
                  updated_at: new Date()
                }
              })
          else
            console.log 'Purchase with id ' + purchaseId + ' not found'

        console.log 'Coins paid', paidAmount, paidCurrency
    return

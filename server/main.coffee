Meteor.startup (->
  # code to run on server at startup

  # make test item if it's a new database
  if Items.find().count() == 0
    Items.insert({
        title: 'Little pony'
        type: 'digital'
        description: 'Little pony that everyone loves. Just a test item that allows you to test store and merchant configuration.'
        price: '0.0001'
        currency: 'BTC'
        quantity: 9999
    })

  if Meteor.users.find().count() == 0 and (Meteor.settings.startup? and Meteor.settings.startup.adminUser?)
    adminId = Accounts.createUser({ email: Meteor.settings.startup.adminUser.email, password: Meteor.settings.startup.adminUser.password})
    Roles.addUsersToRoles(adminId, ['administrator'])
)

Meteor.methods
  cancelPurchase: (purchaseId) ->
    console.log 'cancelPurchase called', purchaseId
    purchase = Purchases.findOne(purchaseId)
    if purchase? and purchase.status != 'paid'
      Purchases.update(purchaseId, {
        $set: {
          status: 'cancelled'
          updated_at: new Date()
        }
      })

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

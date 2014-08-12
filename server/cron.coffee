expireUnpaidPurchases = () ->
  #expire unpaid purchases older than 4 hours
  console.log 'expireUnpaidPurchases task'
  expirationTime = new Date((new Date()) - 1000*60*60*4)
  expiredPurchases = Purchases.find({
    created_at: { $lt: expirationTime }
    status:'awaiting_payment'
  },{ fields: {_id: true} })

  expiredPurchases.forEach (purchase) ->
    #console.log 'cancelPurchase called for expired purchase', purchase._id
    Meteor.call 'cancelPurchase', purchase._id, (err, result) ->
      console.log err if err?

updateGatewayCurrencies = () ->
  #check gateway for available currencies
  console.log 'populateAvailableCurrencies task'
  Meteor.call 'populateAvailableCurrencies', (err, result) ->
    console.log err if err?

# only basic cron syntax is supported, refer to http://atmospherejs.com/package/cron
cron = new Meteor.Cron( {
  events:
    "0 * * * *" : expireUnpaidPurchases
    "0 * * * *" : updateGatewayCurrencies
})

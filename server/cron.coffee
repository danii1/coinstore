expireUnpaidPurchases = () ->
  #expire unpaid purchases older than 4 hours
  expirationTime = new Date((new Date()) - 1000*60*60*4)
  Purchases.update({
    created_at: { $lt: expirationTime }
    status:'awaiting_payment'
  }, {
    $set: {
      status: 'cancelled'
      updated_at: new Date()
    }
  })

# only basic cron syntax is supported, refer to http://atmospherejs.com/package/cron
cron = new Meteor.Cron( {
  events:
    "0 * * * *" : expireUnpaidPurchases
})

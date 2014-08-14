Meteor.startup (->
  Meteor.call 'populateAvailableCurrencies'

  # make test item if it's a new database
  if Items.find().count() == 0
    Items.insert({
        title: 'Little pony'
        type: 'digital'
        description: 'Little pony that everyone loves. Just a test item that allows you to test store and merchant configuration.'
        price: '0.0001'
        currency: 'BTC'
        quantity: 9999
        deliveryType: 'protected_download'
    })

  if Meteor.users.find().count() == 0 and (Meteor.settings.startup.adminUser?)
    adminId = Accounts.createUser({ email: Meteor.settings.startup.adminUser.email, password: Meteor.settings.startup.adminUser.password})
    Roles.addUsersToRoles(adminId, ['administrator'])
)

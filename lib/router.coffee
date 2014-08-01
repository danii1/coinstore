Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'

mustBeAdmin = (pause) ->
  currentUser = Meteor.user()
  unless currentUser? and Roles.userIsInRole(currentUser, ['administrator'])
    @render 'unauthorized'
    pause()

mustBeSignedIn = (pause) ->
  unless Meteor.user()?
    @render 'unauthorized'
    pause()

Router.onBeforeAction(mustBeAdmin, {only: ['adminItems', 'adminItem', 'adminItemNew', 'adminPurchases']})
Router.onBeforeAction(mustBeSignedIn, {only: ['purchases', 'purchase']})
Router.onBeforeAction('loading', {except: ['purchaseReturnUrl', 'purchaseComplete']} )

Router.map ->
  @route('storefront', {
    path: '/'
    onAfterAction: ->
      setTitle(null)
  })
  @route('item', {
    path: '/items/:_id'
    waitOn: ->
      Meteor.subscribe('itemDetail', @params._id)
    data: ->
      return Items.findOne(@params._id)
    onAfterAction: ->
      item = @data()
      setTitle(item.title) if item?
  })
  @route('purchases', {
    path: '/purchases'
    onAfterAction: ->
      setTitle('My purchases')
  })
  @route('purchase', {
    path: '/purchases/:_id'
    data: ->
      return Purchases.findOne(@params._id)
    onAfterAction: ->
      setTitle('Purchase')
  })
  @route('adminItems', {
    path: '/admin/items'
    onAfterAction: ->
      setTitle('Edit items')
  })
  @route('adminPurchases', {
    path: '/admin/purchases'
    onAfterAction: ->
      setTitle('Store purchases')
  })
  @route('adminItem', {
    path: '/admin/items/:_id/edit'
    template: 'edit'
    waitOn: ->
      return Meteor.subscribe('itemDetail', @params._id)
    data: ->
      return Items.findOne(@params._id)
    onAfterAction: ->
      setTitle('Edit item')
  })
  @route('adminItemNew', {
    path: '/admin/items/new'
    template: 'new'
    onAfterAction: ->
      setTitle('New item')
  })
  # return url that will be shown to user after purchase will be completed on merchant side
  @route('purchaseReturnUrl', {
    path: '/purchase'
    where: 'server'
    action: ->
      console.log 'purchase callback', @params
      purchase = Purchases.findOne(@params.ccexmpurchaseid)
      if purchase?
        if @params.result == '0'
          Meteor.call 'cancelPurchase', purchase._id
          @response.writeHead(302, {'Location': '/items/'+purchase.item_id})
          @response.end()
          return
        else if @params.result == '1'
          @response.writeHead(302, {'Location': '/purchases/'+purchase._id})
          @response.end()
          return

      @response.writeHead(302, {'Location': '/'})
      @response.end()
  })
  # this url will be called when merchant gets payment
  @route('purchaseComplete', {
    path: '/purchaseComplete'
    where: 'server'
    action: ->
      console.log 'purchaseComplete callback', this.params

      merchantTransactionId = @params.ccexmid
      currency = @params.ccexmcoin
      amountPaid = @params.ccexmamount
      purchaseId = @params.ccexmpurchaseid

      Meteor.call 'verifyPurchase', merchantTransactionId, purchaseId
  })
